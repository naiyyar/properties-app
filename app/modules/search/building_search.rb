module Search
  module BuildingSearch
    CITIES = ['New York', 'Brooklyn', 'Bronx', 'Queens']

    def buildings_json_hash(searched_buildings)
      unless searched_buildings.class == Array
        searched_buildings.select(:id, :building_name, :building_street_address, 
                                  :latitude, :longitude, :zipcode, :city, 
                                  :min_listing_price,:max_listing_price, :listings_count,
                                  :state, :price).as_json(:methods => [:featured])
      else
        searched_buildings.as_json(:methods => [:featured])
      end
    end

    def with_featured_building buildings, page_num = 1
      final_results = {}
      featured_buildings = featured_buildings(buildings)
      top_two_featured_buildings = if !featured_buildings.nil? && featured_buildings.length > 2
                                      featured_buildings.shuffle[0..1]
                                    else
                                      featured_buildings.shuffle[0..2]
                                    end
      #Selecting 2 featured building to put on top
      page_num = 1 if page_num == 0
      per_page_buildings = buildings.where.not(id: top_two_featured_buildings.map(&:id))
                                          .paginate(:page => page_num, :per_page => 20)
      
      #putting featured building on top
      all_buildings = if top_two_featured_buildings.present?
                        top_two_featured_buildings + per_page_buildings
                      else
                        per_page_buildings
                      end
      if top_two_featured_buildings.present?
        buildings = buildings.where.not(id: top_two_featured_buildings.map(&:id))
        buildings = top_two_featured_buildings + buildings
      end
      #when there are only top two featured buildings after filter
      #then per_page_buildings will be blank due to fitering featured buildings
      per_page_buildings = all_buildings.paginate(:page => page_num, :per_page => 20) if per_page_buildings.blank? && all_buildings.present?
      final_results[:all_buildings] = all_buildings
      final_results[:map_hash] = buildings_json_hash(buildings)
      
      return final_results, per_page_buildings
    end

    def featured_buildings searched_buildings
      ids = searched_buildings.map(&:id)
      fbs = FeaturedBuilding.active_featured_buildings(ids)
      fbs.where(id: fbs.map(&:building_id))
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
      where("building_name ILIKE ? OR 
             building_street_address ILIKE ?", "%#{criteria}%", "%#{criteria}%")
    end

    def buildings_in_neighborhood search_term, term_with_city=nil
      search_term = (search_term == 'Soho' ? 'SoHo' : search_term)
      results = where(neighborhood: search_term)
                .or(where(neighborhoods_parent: search_term))
                .or(where(neighborhood3: search_term))
      
      if search_term == 'Little Italy'
        # Because neighborhood Little italy exist in manhattan as well as Bronx
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

    # Contribute search method
    def text_search(term)
      term.present? ? search(term) : self.all
    end

    def buildings_with_active_listings buildings
      buildings.joins(:listings).where('listings.active is true') rescue nil
    end

    def city_count buildings, city, sub_boroughs = nil
      buildings.where('city = ? OR neighborhood in (?)', city, sub_boroughs).size
    end

    # split view
    def meta_desc buildings, searched_by, options={}
      unless searched_by == 'nyc'
        "#{options[:desc]} has #{options[:count].to_i} no fee apartment, no fee rental, 
        for rent by owner buildings in NYC you can rent directly from and pay no broker fees.
        View #{buildings&.sum(:uploads_count).to_i} photos and #{buildings&.sum(:reviews_count).to_i} reviews."
      else
        "Browse #{options[:count].to_i} No Fee #{pop_search_tab_title(options[:term])}. 
         Bypass the broker and save thousands in fees by renting directly from management companies."
      end
    end

    def pop_search_tab_title search_term
      term = search_term.split('-').join(' ').titleize
      "#{term.gsub!('Nyc', 'NYC')}"
    end
  end
end