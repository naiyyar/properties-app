module BuildingSearch

  def apt_search params, search_string, sub_borough
    results = {}
    results[:filters] = nil
    results[:zoom] = nil
    results[:boundary_coords] = []
    results[:searched_by] = params[:searched_by]
    unless params[:latitude].present? and params[:longitude].present?
      if !['address', 'no-fee-management-companies-nyc'].include?(params[:searched_by])
        results[:zoom] = (search_string == 'New York' ? 12 : 14)
        unless search_string == 'New York'
          if params[:searched_by] == 'zipcode'
            results[:buildings] = buildings_by_zip(search_string).updated_recently
            results[:boundary_coords] << Gcoordinate.where(zipcode: search_string).map{|rec| { lat: rec.latitude, lng: rec.longitude}}
          elsif params[:searched_by] == 'no-fee-apartments-nyc-neighborhoods'
            results[:buildings] = buildings_in_neighborhood(search_string, params[:search_term]).updated_recently
          elsif params[:searched_by] == 'nyc'
            #popular no fee searches
            results[:buildings] = buildings_by_popular_search(params)[0].updated_recently
            results[:filters] = buildings_by_popular_search(params)[1]
            results[:zoom] = 12
          else
            results[:buildings] = cached_buildings_by_city_or_nb(search_string, sub_borough[search_string]).updated_recently
            results[:zoom] = 12
          end
        else
          results[:buildings] = buildings_in_city(search_string).updated_recently
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
      results[:buildings] = redo_search_buildings(params).updated_recently
      results[:zoom] = params[:zoomlevel] || (results[:buildings].length > 90 ? 15 : 14)
    end
    
    results[:buildings] = filtered_buildings(results[:buildings], params[:filter]) if params[:filter].present?
    results[:buildings] = sort_buildings(results[:buildings], params[:sort_by]) if results[:buildings].present?

    return results
  end

  def redo_search_buildings params
    @zoom = params[:zoomlevel].to_i
    custom_latng = [params[:latitude].to_f, params[:longitude].to_f]
    distance = redo_search_distance(0.5)
    buildings = near(custom_latng, distance, units: :km, order: "")
    distance = redo_search_distance(1.0)
    buildings = near(custom_latng, distance, units: :km, order: "") if buildings.blank?

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

  def with_featured_building buildings, page_num=1
    final_results = {}
    featured_buildings = featured_buildings(buildings)
    top_two_featured_buildings = featured_buildings.length >= 2 ? featured_buildings.shuffle[0..2] : featured_buildings
    #Selecting 2 featured building to put on top
    per_page_buildings = buildings.where.not(id: top_two_featured_buildings.map(&:id))
                                        .paginate(:page => page_num, :per_page => 20)
    #putting featured building on top
    if top_two_featured_buildings.present?
      all_buildings = top_two_featured_buildings + per_page_buildings
    else
      all_buildings = per_page_buildings
    end
    if top_two_featured_buildings.present?
      buildings = buildings.where.not(id: top_two_featured_buildings.map(&:id))
      buildings = top_two_featured_buildings + buildings
    end
    final_results[:all_buildings] = all_buildings
    final_results[:map_hash] = buildings_json_hash(buildings)
    
    return final_results, per_page_buildings
  end

  def featured_buildings searched_buildings
    featured_buildings = FeaturedBuilding.active_featured_buildings(searched_buildings.map(&:id))
    searched_buildings.where(id: featured_buildings.map(&:building_id))
  end

  def search_by_zipcodes(criteria)
    # regexp = /#{criteria}/i;
    search_by_zipcode(criteria).order(:zipcode).to_a.uniq(&:zipcode)
    # results.sort{|x, y| (x =~ regexp) <=> (y =~ regexp) } 
  end

  def buildings_by_zip term
    where('zipcode = ?', term)
  end

  def cached_buildings_by_city_or_nb term, sub_borough
    where("city = ? OR neighborhood in (?)", term, sub_borough)
  end

  def search_by_pneighborhoods(criteria)
    search_by_pneighborhood(criteria).order(:neighborhoods_parent).to_a.uniq(&:neighborhoods_parent)
  end

  def search_by_building_name_or_address(criteria)
    where("building_name ILIKE ? OR building_street_address ILIKE ?", "%#{criteria}%", "%#{criteria}%")
  end

  def buildings_in_neighborhood search_term, term_with_city=nil
    search_term = (search_term == 'Soho' ? 'SoHo' : search_term)
    results = where("neighborhood = ? OR neighborhoods_parent = ? OR neighborhood3 = ?", search_term, search_term, search_term)
    if search_term == 'Little Italy'
      #Because neighborhood Little italy exist in manhattan as well as Bronx
      city = term_with_city.include?('newyork') ? 'New York' : 'Bronx'
      results = results.where(city: city)
    end
    results
  end

  def buildings_in_city search_term
    search_by_city(search_term)
  end

  #Contribute search method
  def text_search(term)
    if term.present?
      search(term)
    else
      self.all
    end
  end

  # def filter_by_rates buildings, rating
  #   # 1 star - means  = 1
  #   # 2 star - means  1 <= 2
  #   # 3 star - means  2 <= 3
  #   # 4 star - means  3 <= 4
  #   # 5 star - means  4 <= 5 
  #   if rating.present?
  #     rates = RatingCache.where(cacheable_type: 'Building')
  #     if rating == '1'
  #       rates = rates.where('avg = ?', rating)
  #     else
  #       rates = rates.where('avg > ? AND avg <= ?', rating.to_i-1, rating)
  #     end
  #     buildings.where('id in (?)', rates.map(&:cacheable_id))
  #   else
  #     buildings
  #   end
  # end

  def filter_by_prices buildings, price
    if price.present? and !price.include?('on')
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

  def filter_by_listing_beds buildings, beds
    if buildings.present?
      buildings = buildings_with_active_listings(buildings)
      filtered_buildings = []
      beds.each do |num|
        if num == '0'
          filtered_buildings += buildings.l_studio
        elsif num == '1'
          filtered_buildings += buildings.l_one_bed
        elsif num == '2'
          filtered_buildings += buildings.l_two_bed
        elsif num == '3'
          filtered_buildings += buildings.l_three_bed
        else
          filtered_buildings += buildings.l_four_bed
        end
      end
    end
    buildings.where(id: filtered_buildings.map(&:id).uniq) rescue nil
  end

  def filter_by_listing_prices buildings, min_price, max_price
    if buildings.present?
      buildings = buildings_with_active_listings(buildings)
      buildings.where('listings.rent >= ? AND listings.rent <= ?', min_price.to_i, max_price.to_i)
    end
  end

  # def filter_by_types buildings, type
  #   if type.present?
  #     buildings = buildings.where(building_type: type)
  #   else
  #     buildings = buildings
  #   end
  # end

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
      @buildings = @buildings.management_company_run if has_amenity?('management_company_run')
      @buildings = @buildings.live_in_super if has_amenity?('live_in_super')
      @buildings = @buildings.roof_deck if has_amenity?('roof_deck')
      @buildings = @buildings.pets_allowed_cats if has_amenity?('pets_allowed_cats')
      @buildings = @buildings.pets_allowed_dogs if has_amenity?('pets_allowed_dogs')
      @buildings = @buildings.elevator if has_amenity?('elevator')
      @buildings = @buildings.swimming_pool if has_amenity?('swimming_pool')
      @buildings = @buildings.childrens_playroom if has_amenity?('childrens_playroom')
      @buildings = @buildings.walk_up if has_amenity?('walk_up')
      @buildings = @buildings.no_fee if has_amenity?('no_fee')
      #for listings
      if @amenities.include?('months_free_rent') || @amenities.include?('owner_paid') || @amenities.include?('rent_stabilized')
        @buildings = buildings_with_listing_amenities
      end
    else
      @buildings = buildings
    end
    @buildings
  end

  def has_amenity?(name)
    @amenities.include?(name)
  end

  def buildings_with_listing_amenities
    @buildings = buildings_with_active_listings(@buildings)
    @buildings = @buildings.where('listings.free_months > ?', 0) if has_amenity?('months_free_rent')
    @buildings = @buildings.where('listings.owner_paid is not null') if has_amenity?('owner_paid')
    @buildings = @buildings.where('listings.rent_stabilize = ?', 'true') if has_amenity?('rent_stabilized')
    return @buildings
  end

  def filtered_buildings buildings, filter_params
    #rating = filter_params[:rating]
    #building_types = filter_params[:type]
    price = filter_params[:price]
    beds = filter_params[:bedrooms]
    listing_beds = filter_params[:listing_bedrooms]
    amenities = filter_params[:amenities]
    min_price = filter_params[:min_price]
    max_price = filter_params[:max_price]

    buildings = filter_by_amenities(buildings, amenities) if amenities.present?
    #buildings = filter_by_rates(buildings, rating) if rating.present?
    buildings = filter_by_prices(buildings, price) if price.present? and min_price.blank?
    buildings = filter_by_beds(buildings, beds) if beds.present?
    buildings = filter_by_listing_beds(buildings, listing_beds) if listing_beds.present?
    buildings = filter_by_listing_prices(buildings, min_price, max_price) if min_price.present? and max_price.present?
    #buildings = filter_by_types(buildings, building_types) if building_types.present?
    return buildings
  end

  def sort_buildings(buildings, sort_params)
    # 0 => Default by active listings
    #1.Least Expensive - Listing
      #Sort by lowest listing price available at building with the building with the lowest price displayed at the top
    #2.Most Expensive - Listing
      #Sort by highest listing price available at building with the building with the highest price displayed at the top
    #3.Least Expensive - Building
      #1st sort by dollar sign at the building with the building with the lowest dollar sign displayed at the top
      #2nd sort by Buildings with Active Listings
      #3rd sort by alphabetical A-Z
    #4.Most Expensive - Building
      #1st sort by dollar sign at the building with the building with the highest dollar sign displayed at the top
      #2nd sort by Buildings with Active Listings
      #3rd sort by alphabetical A-Z
    if buildings.present?
      case sort_params
      when '1'
        buildings = buildings_with_all_listings(buildings).reorder('listings.rent DESC')
      when '2'
        buildings = buildings_with_all_listings(buildings).reorder('listings.rent ASC')
      when '3'
        sort_order = {price: :asc, listings_count: :desc, building_name: :asc, building_street_address: :asc}
        buildings = buildings.where(id: sorting_buildings_ids(sort_order, buildings)).order(sort_order)
      when '4'
        sort_order = {price: :desc, listings_count: :desc, building_name: :asc, building_street_address: :asc}
        buildings = buildings.where(id: sorting_buildings_ids(sort_order, buildings))
      else
        buildings = buildings
      end
    else
      buildings = buildings
    end
    buildings
  end

  def sorting_buildings_ids sort_order, buildings
    buildings_with_price_ids = buildings.where.not(price: nil)
                                        .select(:id, :building_name, :building_street_address, :price, :listings_count)
                                        .order(sort_order).pluck(:id)
    
    buildings_without_price_ids = buildings.where(price: nil)
                                           .select(:id, :building_name, :building_street_address, :price, :listings_count)
                                           .order({listings_count: :desc, building_name: :asc, building_street_address: :asc})
                                           .pluck(:id)
    return (buildings_with_price_ids + buildings_without_price_ids)
  end

  def buildings_with_active_listings buildings
    buildings.joins(:listings).where('listings.active is true') rescue nil
  end

  def buildings_with_all_listings buildings
    buildings.left_outer_joins(:listings) rescue nil
  end

  ####### OLD SORTING LOGIC BEFORE 13 SEPT 2019
  # def sort_buildings(buildings, sort_params)
  #   # 0 => Default by active listings
  #   # 1 => Rating (high to low)
  #   # 2 => Rating (high to low)
  #   # 3 => Reviews (high to low)
  #   # 4 => A to Z
  #   # 5 => Z to A
  #   if buildings.present?
  #     case sort_params
  #     when '1'
  #       buildings = sort_by_rating(buildings, '1')
  #     when '2'
  #       buildings = sort_by_rating(buildings, '2')
  #     when '3'
  #       buildings = where(id: buildings.map(&:id)).reorder('reviews_count DESC')
  #     when '4'
  #       buildings = buildings.reorder('building_name ASC, building_street_address ASC')
  #     when '5'
  #       buildings = buildings.reorder('building_name DESC, building_street_address DESC')
  #     else
  #       buildings = buildings
  #     end
  #   else
  #     buildings = buildings
  #   end
  #   buildings
  # end

  # def sort_by_rating buildings, sort_index
  #   rated_buildings = buildings.includes(:building_average, :featured_building).where.not(avg_rating: nil)
  #   non_rated_buildings = buildings.includes(:building_average, :featured_building).where.not(id: rated_buildings.pluck(:id))
  #   if sort_index == '1'
  #     rated_buildings = rated_buildings.reorder(avg_rating: :desc, building_name: :asc, building_street_address: :asc)
  #     sort_buildings = rated_buildings + non_rated_buildings
  #   else
  #     rated_buildings = rated_buildings.reorder(avg_rating: :asc, building_name: :asc, building_street_address: :asc)
  #     sort_buildings = non_rated_buildings + rated_buildings
  #   end
  #   buildings.where(id: sort_buildings.map(&:id))
  # end

end