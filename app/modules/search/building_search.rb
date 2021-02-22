module Search
  module BuildingSearch
    def buildings_json_hash(buildings, featured_comp_building_id = nil)
      unless buildings.class == Array
        buildings.select(*attrs_to_select)
                 .as_json(:methods => json_hash_methods(featured_comp_building_id))
      else
        buildings.as_json(:methods => json_hash_methods(featured_comp_building_id))
      end
    end

    def json_hash_methods featured_comp_building_id
      return [:featured?, :featured, :property_type] if featured_comp_building_id.blank?
      [:featured?, :featured, :featured_comp_building_id, :property_type]
    end

    def attrs_to_select
      [ :id, :building_name, :building_street_address, 
        :latitude, :longitude, :zipcode, :city, 
        :min_listing_price,:max_listing_price, :listings_count,
        :state, :price, :featured_buildings_count]
    end
    
    def no_sorting? sort_by
      sort_by.blank? || sort_by == '0'
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
      Rails.cache.fetch([self, city, 'city_count']) {
        buildings.where('city = ? OR neighborhood in (?)', city, sub_boroughs).size
      }
    end
  end
end