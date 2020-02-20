module BuildingSearch
  CITIES = ['New York', 'Brooklyn', 'Bronx', 'Queens']
  def apt_search params, search_string, sub_borough
    results                   = {}
    results[:filters]         = nil
    results[:zoom]            = nil
    results[:boundary_coords] = []
    results[:searched_by]     = params[:searched_by]
    unless params[:latitude].present? and params[:longitude].present?
      if !['address', 'no-fee-management-companies-nyc'].include?(params[:searched_by])
        results[:zoom] = (search_string == 'New York' ? 12 : 14)
        unless search_string == 'New York'
          if params[:searched_by] == 'zipcode'
            results[:buildings] = buildings_by_zip(search_string)
            results[:boundary_coords] << Gcoordinate.where(zipcode: search_string).map{|rec| { lat: rec.latitude, lng: rec.longitude}}
          elsif params[:searched_by] == 'no-fee-apartments-nyc-neighborhoods'
            results[:buildings] = buildings_in_neighborhood(search_string, params[:search_term])
          elsif params[:searched_by] == 'nyc'
            #popular no fee searches
            results[:buildings] = buildings_by_popular_search(params)[0]
            results[:filters]   = buildings_by_popular_search(params)[1]
            results[:zoom]      = 12
          else
            results[:buildings] = cached_buildings_by_city_or_nb(search_string, sub_borough[search_string])
            results[:zoom]      = 12
          end
        else
          results[:buildings] = buildings_in_city(search_string)
        end
      elsif params[:searched_by] == 'address'
        building           = where(building_street_address: params[:search_term])
        #searching because some address has extra white space in last so can not match exactly with address search_term
        building           = where('building_street_address like ?', "%#{params[:search_term]}%") if building.blank?
        results[:building] = building
      elsif params[:searched_by] == 'no-fee-management-companies-nyc'
        results[:company] = ManagementCompany.where(name: params[:search_term])
      end
    else
      results[:buildings] = redo_search_buildings(params)
      results[:zoom]      = params[:zoomlevel] || (results[:buildings].length > 90 ? 15 : 14)
    end
    results[:buildings] = results[:buildings].updated_recently if(params[:sort_by].blank? or params[:sort_by] == '0')
    results[:buildings] = filtered_buildings(results[:buildings], params[:filter]) if params[:filter].present?
    results[:buildings] = sort_buildings(results[:buildings], params[:sort_by]) if(results[:buildings].present? and params[:sort_by] != '0')

    return results
  end

  def redo_search_buildings params
    @zoom         = params[:zoomlevel].present? ? params[:zoomlevel].to_i : 14
    custom_latng  = [params[:latitude].to_f, params[:longitude].to_f]
    distance      = redo_search_distance(0.5)
    buildings     = near(custom_latng, distance, units: :km, order: '')
    distance      = redo_search_distance(1.0)
    buildings     = near(custom_latng, distance, units: :km, order: '') if buildings.blank?

    buildings
  end

  def redo_search_distance distance
    if @zoom >= 14
      distance = distance/(@zoom)
      case @zoom
      when 14 then distance += 1.5
      when 15 then distance += 0.8
      when 16 then distance += 0.5
      when 17 then distance += 0.2
      else
        distance += 0.1
      end
    else
      case @zoom
      when 13 then distance += 3
      when 12 then distance += 4
      when 11 then distance += (@zoom * 2)
      else
        distance += (@zoom * 2.5)
      end
    end
    distance
  end

  def with_featured_building buildings, page_num=1
    final_results = {}
    featured_buildings = featured_buildings(buildings)
    #top_two_featured_buildings = featured_buildings
    if !featured_buildings.nil? and featured_buildings.length > 2
      top_two_featured_buildings = featured_buildings.shuffle[0..1]
    else
      top_two_featured_buildings = featured_buildings.shuffle[0..2]
    end
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
    #when there are only top two featured buildings after filter
    #then per_page_buildings will be blank due to fitering featured buildings
    per_page_buildings = all_buildings.paginate(:page => page_num, :per_page => 20) if per_page_buildings.blank? and all_buildings.present?
    final_results[:all_buildings] = all_buildings
    final_results[:map_hash] = buildings_json_hash(buildings)
    
    return final_results, per_page_buildings
  end

  def featured_buildings searched_buildings
    featured_buildings = FeaturedBuilding.active_featured_buildings(searched_buildings.map(&:id))
    searched_buildings.where(id: featured_buildings.map(&:building_id))
  end

  def search_by_zipcodes(criteria)
    search_by_zipcode(criteria).order(:zipcode).to_a.uniq(&:zipcode)
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

  #results = where("neighborhood = ? OR neighborhoods_parent = ? OR neighborhood3 = ?", search_term, search_term, search_term)
  def buildings_in_neighborhood search_term, term_with_city=nil
    search_term = (search_term == 'Soho' ? 'SoHo' : search_term)
    results = where(neighborhood: search_term)
              .or(where(neighborhoods_parent: search_term))
              .or(where(neighborhood3: search_term))
    
    if search_term == 'Little Italy'
      #Because neighborhood Little italy exist in manhattan as well as Bronx
      city    = term_with_city.include?('newyork') ? 'New York' : 'Bronx'
      results = results.where(city: city)
    end
    results
  end

  def buildings_in_city search_term
    if search_term == 'New York'
      where(city: CITIES)
    else
      where(city: search_term)
    end
  end

  #Contribute search method
  def text_search(term)
    term.present? ? search(term) : self.all
  end

  def buildings_with_active_listings buildings
    buildings.joins(:listings).where('listings.active is true') rescue nil
  end
end