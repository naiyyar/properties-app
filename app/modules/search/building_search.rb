module Search
  module BuildingSearch
    def buildings_json_hash(searched_buildings)
      unless searched_buildings.class == Array
        searched_buildings.select(:id, :building_name, :building_street_address, 
                                  :latitude, :longitude, :zipcode, :city, 
                                  :min_listing_price,:max_listing_price, :listings_count,
                                  :state, :price, :featured_buildings_count)
                                  .as_json(:methods => json_hash_methods)
      else
        searched_buildings.as_json(:methods => json_hash_methods)
      end
    end

    def json_hash_methods
      [:featured?, :featured, :featured_comp_building_id]
    end
    
    def no_sorting? sort_by
      sort_by.blank? || sort_by == '0'
    end
    
    def with_featured_building buildings, search_terms, sort_by, filters, page_num = 1
      search_string, searched_by = search_terms
      page_num           = 1 if page_num == 0
      @filters           = filters
      final_results      = {}
      top2_featured      = top2_featured_buildings(buildings, searched_by)
      non_featured       = non_featured_buildings(buildings, top2_featured, sort_by)
      per_page_buildings = non_featured.paginate(:page => page_num, :per_page => 20)
      all_buildings      = buildings_with_featured_on_top(top2_featured, per_page_buildings)
      
      buildings = top2_featured + non_featured if top2_featured.present?
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

    def non_featured_buildings buildings, top_2, sort_by
      buildings = buildings.where.not(id: top_2.map(&:id)) if top_2.present?
      return buildings.sort_buildings(buildings, sort_by, @filters)
    end

    def top2_featured_buildings buildings, searched_by
      fb_ids = featured_building_ids(buildings.pluck(:id), searched_by)
      return [] if fb_ids.blank?
      shuffled_ids = fb_ids.shuffle[0..1]
      if fb_ids.length > 0
        unless searched_by == 'nyc'
          buildings.where(id: shuffled_ids) 
        else
          Building.where(id: shuffled_ids)
        end
      end
    end

    def featured_building_ids ids, searched_by
      fbs = FeaturedBuilding.active
      fbs = fbs.where(building_id: ids) unless searched_by == 'nyc'
      fbs.pluck(:building_id)
    end

    def search_by_zipcodes(criteria)
      search_by_zipcode(criteria).order(:zipcode).to_a.uniq(&:zipcode)
    end

    def buildings_by_zip term
      where('zipcode = ?', term)
    end

    def cached_buildings_by_city_or_nb term, sub_borough
      where('city = ? OR neighborhood in (?)', term, sub_borough)
    end

    def search_by_pneighborhoods(criteria)
      search_by_pneighborhood(criteria).order(:neighborhoods_parent).to_a.uniq(&:neighborhoods_parent)
    end

    def search_by_building_name_or_address(criteria)
      where('building_name ILIKE ? OR 
             building_street_address ILIKE ?', "%#{criteria}%", "%#{criteria}%")
    end

    def buildings_in_neighborhood search_term, term_with_city = nil
      results = where('LOWER(neighborhood) = ? 
                      OR LOWER(neighborhoods_parent) = ? 
                      OR LOWER(neighborhood3) = ? 
                      OR LOWER(city) = ?', search_term, 
                                           search_term, 
                                           search_term, 
                                           search_term )
      # Neighborhood Little italy exist in manhattan as well as Bronx
      return results unless search_term == 'Little Italy'
      results.where(city: nb_city(term_with_city))
    end

    def nb_city term_with_city
      (!term_with_city.nil? && term_with_city.include?('newyork')) ? 'New York' : 'Bronx'
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

    def city_count buildings, city, sub_boroughs = nil
      buildings.where('city = ? OR neighborhood in (?)', city, sub_boroughs).size
    end

    # split view
    def meta_desc buildings, searched_by, options={}
      unless searched_by == 'nyc'
        "#{options[:desc]} has #{options[:count].to_i} no fee apartment, no fee rental, 
        for rent by owner buildings in NYC you can rent directly from and pay no broker fees.
        View #{buildings&.sum(:uploads_count)} photos and #{buildings&.sum(:reviews_count)} reviews."
      else
        "Browse #{options[:count].to_i} No Fee #{pop_search_tab_title(options[:term])}. 
         Bypass the broker and save thousands in fees by renting directly from management companies."
      end
    end

    def pop_search_tab_title search_term
      term = search_term.split('-').join(' ').titleize
      "#{term.gsub!('Nyc', 'NYC')}"
      return term
    end
  end
end