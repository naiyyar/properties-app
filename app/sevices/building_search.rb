module BuildingSearch

	def apt_search params, search_string, sub_borough
    results = {}
    results[:zoom] = nil
    results[:boundary_coords] = []
    results[:searched_by] = params[:searched_by]
    unless params[:latitude].present? and params[:longitude].present?
      if !['address', 'no-fee-management-companies-nyc'].include?(params[:searched_by])
        results[:zoom] = (search_string == 'New York' ? 12 : 14)
        unless search_string == 'New York'
          if params[:searched_by] == 'zipcode'
            results[:buildings] = cached_buildings_by_zip('zipcode', search_string)
            results[:boundary_coords] << Gcoordinate.where(zipcode: search_string).map{|rec| { lat: rec.latitude, lng: rec.longitude}}
          elsif params[:searched_by] == 'no-fee-apartments-nyc-neighborhoods'
            results[:buildings] = buildings_in_neighborhood(search_string)
          else
            results[:buildings] = cached_buildings_by_city_or_nb(search_string, sub_borough[search_string])
            results[:zoom] = 12
          end
        else
          results[:buildings] = buildings_in_city(search_string)
        end
      elsif params[:searched_by] == 'address'
        building = where(building_street_address: params[:search_term])
        #searching because some address has extra white space in last so can not match exactly with address search_term
        building = where('building_street_address like ?', "%#{params[:search_term]}%") if building.blank?
        results[:building] = building
      elsif params[:searched_by] == 'no-fee-management-companies-nyc'
        results[:company] = ManagementCompany.where(name: params[:search_term])
      end
    else
      results[:buildings] = redo_search_buildings(params)
      results[:zoom] = params[:zoomlevel] || 13
    end

    results[:buildings] = filtered_buildings(results[:buildings], params[:filter]) if params[:filter].present?
    results[:buildings] = sort_buildings(results[:buildings], params[:sort_by]) if (params[:sort_by].present? and results[:buildings].present?)

    return results
  end

	def redo_search_buildings params
    @zoom = params[:zoomlevel].to_i
    custom_latng = [params[:latitude].to_f, params[:longitude].to_f]
    distance = redo_search_distance(1.5)
    buildings = near(custom_latng, distance, units: :km)
    distance = redo_search_distance(2.0)
    buildings = near(custom_latng, distance, units: :km) if buildings.blank?
    distance = redo_search_distance(4.5)
    buildings = near(custom_latng, distance, units: :km) if buildings.blank?

    buildings
  end

  def redo_search_distance distance
    if @zoom > 14
      distance = distance/(@zoom)
      case @zoom
      when 15
        distance += 0.8
      when 16
        distance += 0.5
      when 17
        distance += 0.2
      when 18
        distance += 0.1
      else
        distance
      end
    end
    distance
  end

  def broker_percent
    BrokerFeePercent.first.percent_amount
  end

  def with_featured_building buildings, page_num=1
  	final_results = {}
    featured_buildings = Building.active_featured_buildings(buildings).includes(:building_average, :featured_building)
    top_two_featured_buildings = featured_buildings.length > 2 ? featured_buildings.shuffle[1..2] : []
    #Selecting 2 featured building to put on top
    per_page_buildings = buildings.where.not(id: top_two_featured_buildings.map(&:id))
                                        .paginate(:page => page_num, :per_page => 20)
    #putting featured building on top
    if top_two_featured_buildings.present?
      all_buildings = top_two_featured_buildings + per_page_buildings
    else
      all_buildings = per_page_buildings
    end

    all_buildings.each do |b| 
      images = b.chached_image_uploads
      b.first_image = images[0]
      b.uploaded_images_count = images.count
      b.min_saved_amount = b.min_save_amount(broker_percent)
    end

    if top_two_featured_buildings.present?
      if buildings.kind_of? Array
        buildings = buildings - top_two_featured_buildings
      else
        buildings = buildings.where.not(id: top_two_featured_buildings.map(&:id))
      end
      buildings = top_two_featured_buildings + buildings
    end
    
    final_results[:all_buildings] = all_buildings
    final_results[:map_hash] = buildings_json_hash(buildings)
    
    return final_results, per_page_buildings
  end

	def search_by_zipcodes(criteria)
    # regexp = /#{criteria}/i;
    search_by_zipcode(criteria).order(:zipcode).to_a.uniq(&:zipcode)
    # results.sort{|x, y| (x =~ regexp) <=> (y =~ regexp) } 
  end

  def cached_buildings_by_zip searched_by, term
    Rails.cache.fetch([self, searched_by, term]) { where('zipcode = ?', term) }
  end

  def cached_buildings_by_city_or_nb term, sub_borough
    Rails.cache.fetch([self, term, 'city']) { where("city = ? OR neighborhood in (?)", term, sub_borough) }
  end

  def search_by_pneighborhoods(criteria)
    search_by_pneighborhood(criteria).order(:neighborhoods_parent).to_a.uniq(&:neighborhoods_parent)
  end

  def search_by_building_name(criteria)
    text_search_by_building_name(criteria).reorder('building_name ASC')
  end

  def buildings_in_neighborhood search_term
    search_term = (search_term == 'Soho' ? 'SoHo' : search_term)
    Rails.cache.fetch([self, search_term, 'neighborhoods']) { where("neighborhood = ? OR neighborhoods_parent = ? OR neighborhood3 = ?", search_term, search_term, search_term) }
  end

  def buildings_in_city city
    Rails.cache.fetch([self, city, 'city']) { where("city @@ :q" , q: city) }
  end

  #Contribute search method
  def text_search(term)
    if term.present?
      search(term)
    else
      self.all
    end
  end

	def filter_by_rates buildings, rating
    # 1 star - means  = 1
    # 2 star - means  1 <= 2
    # 3 star - means  2 <= 3
    # 4 star - means  3 <= 4
    # 5 star - means  4 <= 5 
    if rating.present?
      rates = RatingCache.where(cacheable_type: 'Building')
      if rating == '1'
        rates = rates.where('avg = ?', rating)
      else
        rates = rates.where('avg > ? AND avg <= ?', rating.to_i-1, rating)
      end
      buildings.where('id in (?)', rates.map(&:cacheable_id))
    else
      buildings
    end
  end

  def filter_by_prices buildings, price
    if price.present?
      buildings = buildings.where(price: price) if buildings.present?
    else
      buildings = buildings
    end
  end

  def filter_by_beds buildings, beds
    if buildings.present?
      @buildings = []
      beds.each do |num|
        if num == '0'
          @buildings += buildings.studio
        elsif num == '1'
          @buildings += buildings.one_bed
        elsif num == '2'
          @buildings += buildings.two_bed
        elsif num == '3'
          @buildings += buildings.three_bed
        else
          @buildings += buildings.four_bed
        end
      end
    end
    buildings.where(id: @buildings.map(&:id).uniq) rescue nil
  end

  def filter_by_types buildings, type
    if type.present?
      buildings = buildings.where(building_type: type)
    else
      buildings = buildings
    end
  end

  def filter_by_amenities buildings, amenities
    @amenities = amenities
    if amenities.present?
      @buildings = buildings
      @buildings = @buildings.doorman if has_amenity?('doorman')
      @buildings = @buildings.courtyard if has_amenity?('courtyard')
      @buildings = @buildings.laundry_facility if has_amenity?('laundry_facility')
      @buildings = @buildings.parking if has_amenity?('parking')
      @buildings = @buildings.gym if has_amenity?('gym')
      @buildings = @buildings.garage if has_amenity?('garage')
      @buildings = @buildings.mgmt_company_run if has_amenity?('management_company_run')
      @buildings = @buildings.live_in_super if has_amenity?('live_in_super')
      @buildings = @buildings.roof_deck if has_amenity?('roof_deck')
      @buildings = @buildings.pets_allowed_cats if has_amenity?('pets_allowed_cats')
      @buildings = @buildings.pets_allowed_dogs if has_amenity?('pets_allowed_dogs')
      @buildings = @buildings.elevator if has_amenity?('elevator')
      @buildings = @buildings.swimming_pool if has_amenity?('swimming_pool')
      @buildings = @buildings.childrens_playroom if has_amenity?('childrens_playroom')
      @buildings = @buildings.walk_up if has_amenity?('walk_up')
      @buildings = @buildings.no_fee if has_amenity?('no_fee')
    else
      @buildings = buildings
    end
    @buildings
  end

  def has_amenity?(name)
    @amenities.include?(name)
  end

  def filtered_buildings buildings, filter_params
    rating = filter_params[:rating]
    building_types = filter_params[:type]
    price = filter_params[:price]
    beds = filter_params[:bedrooms]
    amenities = filter_params[:amenities]
  
    buildings = filter_by_amenities(buildings, amenities) if amenities.present?
    buildings = filter_by_rates(buildings, rating) if rating.present?
    buildings = filter_by_prices(buildings, price) if price.present?
    buildings = filter_by_beds(buildings, beds) if beds.present?
    buildings = filter_by_types(buildings, building_types)

    return buildings
  end

  def sort_buildings(buildings, sort_params)
    # 0 => Default
    # 1 => Rating (high to low)
    # 2 => Rating (high to low)
    # 3 => Reviews (high to low)
    # 4 => A to Z
    # 5 => Z to A
    if buildings.present?
      case sort_params
      when '1'
        buildings = sort_by_rating(buildings, '1')
      when '2'
        buildings = sort_by_rating(buildings, '2')
      when '3'
        #buildings = buildings.reorder('reviews_count DESC')
        buildings = where(id: buildings.map(&:id)).reorder('reviews_count DESC')
      when '4'
        buildings = buildings.reorder('building_name ASC, building_street_address ASC')
      when '5'
        buildings = buildings.reorder('building_name DESC, building_street_address DESC')
      else
        buildings = buildings
      end
    else
      buildings = buildings
    end
    buildings
  end

  def sort_by_rating buildings, sort_index
    rated_buildings = buildings.includes(:building_average, :featured_building).where.not(avg_rating: nil)
    non_rated_buildings = buildings.includes(:building_average, :featured_building).where.not(id: rated_buildings.pluck(:id))
    if sort_index == '1'
      rated_buildings = rated_buildings.reorder(avg_rating: :desc, building_name: :asc, building_street_address: :asc)
      sort_buildings = rated_buildings + non_rated_buildings
    else
      rated_buildings = rated_buildings.reorder(avg_rating: :asc, building_name: :asc, building_street_address: :asc)
      sort_buildings = non_rated_buildings + rated_buildings
    end
    buildings.where(id: sort_buildings.map(&:id))
  end

end