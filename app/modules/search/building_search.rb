module Search
  module BuildingSearch
    def buildings_json_hash(searched_buildings)
      unless searched_buildings.class == Array
        searched_buildings.select(:id, :building_name, :building_street_address, 
                                  :latitude, :longitude, :zipcode, :city, 
                                  :min_listing_price,:max_listing_price, :listings_count,
                                  :state, :price).as_json(:methods => [:featured?, :featured])
      else
        searched_buildings.as_json(:methods => [:featured?, :featured])
      end
    end

    def with_featured_building buildings, page_num = 1
      page_num                     = 1 if page_num == 0
      final_results                = {}
      
      featured_buildings           = featured_buildings(buildings)
      top2_featured_buildings      = featured_buildings.limit(2)
      buildings_other_than_top_two = non_featured_buildings(buildings, top2_featured_buildings)
      per_page_buildings           = buildings_other_than_top_two.paginate(:page => page_num, :per_page => 20)
      all_buildings                = buildings_with_featured_on_top(top2_featured_buildings, per_page_buildings)
      
      if top2_featured_buildings.present?
        buildings = top2_featured_buildings + buildings_other_than_top_two
      end
      # when there are only top two featured buildings after filter
      # then per_page_buildings will be blank due to fitering featured buildings
      if per_page_buildings.blank? && all_buildings.present?
        per_page_buildings = all_buildings.paginate(:page => page_num, :per_page => 20)
      end
      final_results[:all_buildings] = all_buildings
      final_results[:map_hash]      = buildings_json_hash(buildings)
      
      return final_results, per_page_buildings
    end

    # putting featured building on top
    def buildings_with_featured_on_top top_2, per_page
      top_2.present? ? (top_2 + per_page) : per_page
    end

    def non_featured_buildings buildings, top_2
      buildings.where.not(id: top_2.map(&:id))
    end

    def featured_buildings searched_buildings
      fbs = FeaturedBuilding.active_featured_buildings(searched_buildings.map(&:id))
      searched_buildings.where(id: fbs.map(&:building_id)).reorder('RANDOM()')
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
        city    = (!term_with_city.nil? && term_with_city.include?('newyork')) ? 'New York' : 'Bronx'
        results = results.where(city: city)
      end
      results
    end

    def buildings_in_city search_term
      if search_term == 'New York'
        where(city: Building::CITIES)
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