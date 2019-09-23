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
    if buildings.present?
      case sort_params
      when '1'
        buildings = buildings.where(id: (sorted_listed_building_ids(buildings, sort_params))).order_by_min_rent
      when '2'
        buildings = buildings.order('max_listing_price DESC NULLS LAST')
      when '3'
        buildings = buildings.where(id: sorting_buildings_ids(buildings, sort_params)).order_by_min_price
      when '4'
        buildings = buildings.order('price DESC NULLS LAST, listings_count DESC, building_name ASC, building_street_address ASC')
      else
        buildings = buildings
      end
    else
      buildings = buildings
    end
    buildings
  end

  def sorted_listed_building_ids buildings, sort_by
  	ids_arr = []
  	filtered_buildings = where(id: buildings.pluck(:id))
    ids_arr += filtered_buildings.where.not(min_listing_price: nil).with_active_listing.order_by_min_rent.pluck(:id)
    ids_arr += buildings.where(min_listing_price: nil).pluck(:id)
    return ids_arr
  end

  def sorting_buildings_ids buildings, sort_params
  	ids_arr = []
  	filtered_buildings = where(id: buildings.pluck(:id))
    ids_arr += filtered_buildings.where.not(price: nil).order_by_min_price.pluck(:id)
    ids_arr += buildings.where(price: nil).pluck(:id)
    return ids_arr
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