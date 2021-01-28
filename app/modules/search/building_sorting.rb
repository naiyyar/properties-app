module Search
  module BuildingSorting
    SORT_BY_ASC = 'ASC'
    SORT_BY_DESC = 'DESC'
    
    def sort_buildings(buildings, sort_params, filters = {})
      if filters.present?
        @filters     = filters[:listings]
        @filter_keys = @filters&.keys
      end
      @buildings   = buildings
      @sort_params = sort_params
      
      return @buildings.updated_recently unless sort_params.present?
      sorted_building_by_sort_num
    end

    private

    def sorted_building_by_sort_num
      buildings = 
        case @sort_params
        when '1'
          @buildings = @buildings.where(id: sorted_building_ids_by_min_price)
          return least_exp_sorted_listings if has_listing_type_filters?
          @buildings.order_by_min_rent
        when '2'
          @buildings = @buildings.where(id: sorted_building_ids_by_max_price)
          return most_exp_sorted_listings if has_listing_type_filters?
          @buildings.order_by_max_rent
        when '3'
          return least_exp_sorted_buildings if has_listing_type_filters?
          @buildings.order_by_min_price
        when '4'
          return most_exp_sorted_buildings if has_listing_type_filters?
          @buildings.order_by_max_price
        else
          return sorted_by_recently_updated if has_listing_type_filters?
          @buildings.updated_recently
        end
      return buildings
    end

    def has_listing_type_filters?
      @filters.present? && has_listing_filters?
    end

    def has_listing_filters?
      @filter_keys.include?('listing_bedrooms') || @filter_keys.include?('min_price')
    end

    def least_exp_sorted_listings
      sorted_buildings_by(sorted_building_ids_by_rent(SORT_BY_ASC))
    end

    # sort by most expensive listings
    def most_exp_sorted_listings
      sorted_buildings_by(sorted_building_ids_by_rent(SORT_BY_DESC))
    end

    def least_exp_sorted_buildings
      sorted_buildings_by(sorted_buildings_ids_by_price(SORT_BY_ASC))
    end

    def most_exp_sorted_buildings
      sorted_buildings_by(sorted_buildings_ids_by_price(SORT_BY_DESC))
    end

    def sorted_buildings_by ids
      return transparentcity_buildings if ids.empty?
      transparentcity_buildings.order_by_id_pos(ids)
    end

    def sorted_building_ids_by_rent sort_order
      @buildings.select('listings.rent, buildings.*')
               .reorder("listings.rent #{sort_order} NULLS LAST")
               .map(&:id)
               .uniq
    end

    def sorted_buildings_ids_by_price sort_order
      buildings = if sort_order == 'ASC'
                    @buildings.order_by_min_price
                  elsif sort_order == 'DESC'
                    @buildings.order_by_max_price
                  end
      return buildings.map(&:id).uniq
    end

    # 1.Least Expensive - Listing
    def sorted_building_ids_by_min_price
      ids_arr = []
      ids_arr += filtered_properties.where.not(min_listing_price: nil)
                                   .with_active_listing
                                   .order_by_min_rent
                                   .map(&:id)
      ids_arr += @buildings.where(min_listing_price: nil).ids
      return ids_arr
    end

    # 2.Most Expensive - Listing
    def sorted_building_ids_by_max_price
      ids_arr = []
      ids_arr += filtered_properties.where.not(max_listing_price: nil)
                                   .with_active_listing
                                   .order_by_max_rent
                                   .map(&:id)
      ids_arr += @buildings.where(max_listing_price: nil).ids
      return ids_arr
    end

    # 3.Least Expensive - Building
    def sorting_buildings_ids
      ids_arr = []
      ids_arr += filtered_properties.where.not(price: nil)
                                   .order_by_min_price
                                   .map(&:id)
      ids_arr += @buildings.where(price: nil).ids
      return ids_arr
    end

    def filtered_properties
      @filtered_properties ||= where(id: @buildings.ids)
    end

    def sorted_by_recently_updated
      ids = @buildings.pluck(:id)
      return @buildings.updated_recently if ids.empty?
      sorted_buildings_by(@buildings.pluck(:id).uniq)
    end
  end
end