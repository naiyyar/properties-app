module Search
  module BuildingSorting
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
      case sort_params
      when '1'
        buildings = buildings.where(id: (sorted_building_ids_by_min_price(buildings))).order_by_min_rent
      when '2'
        buildings = buildings.where(id: (sorted_building_ids_by_max_price(buildings))).order_by_max_rent
      when '3'
        buildings = buildings.where(id: sorting_buildings_ids(buildings)).order_by_min_price
      when '4'
        buildings = buildings.order('price DESC NULLS LAST, 
                                     listings_count DESC, 
                                     building_name ASC, 
                                     building_street_address ASC')
      else
        buildings = buildings
      end
      
      buildings
    end

    # 1.Least Expensive - Listing
    def sorted_building_ids_by_min_price buildings
      ids_arr = []
      filtered_buildings = where(id: buildings.pluck(:id))
      ids_arr += filtered_buildings.where.not(min_listing_price: nil)
                                   .with_active_listing
                                   .order_by_min_rent
                                   .map(&:id)
      ids_arr += buildings.where(min_listing_price: nil).pluck(:id)
      return ids_arr
    end

    # 2.Most Expensive - Listing
    def sorted_building_ids_by_max_price buildings
      ids_arr = []
      filtered_buildings = where(id: buildings.pluck(:id))
      ids_arr += filtered_buildings.where.not(max_listing_price: nil)
                                   .with_active_listing
                                   .order_by_max_rent
                                   .map(&:id)
      ids_arr += buildings.where(max_listing_price: nil).pluck(:id)
      return ids_arr
    end

    # 3.Least Expensive - Building
    def sorting_buildings_ids buildings
      ids_arr = []
      filtered_buildings = where(id: buildings.pluck(:id))
      ids_arr += filtered_buildings.where.not(price: nil)
                                   .order_by_min_price
                                   .map(&:id)
      ids_arr += buildings.where(price: nil).pluck(:id)
      return ids_arr
    end
  end
end