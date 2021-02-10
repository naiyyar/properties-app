module Buildings
	module FeaturedBuildings
		PER_PAGE = 20

		def with_featured_buildings buildings, featured_listings=nil
	    final_results      = {all_buildings: nil, map_hash: nil}
	    top2_featured      = top2_featured_buildings(buildings)
	    non_featured       = non_featured_buildings(buildings, top2_featured)
	    per_page_buildings = non_featured.paginate(:page => page_num, :per_page => PER_PAGE)
	    all_buildings      = buildings_with_featured_on_top(top2_featured, per_page_buildings)
	    
	    buildings = top2_featured + non_featured if top2_featured.present?
	    # when there are only top two featured buildings after filter
	    # then per_page_buildings will be blank due to fitering featured buildings
	    if per_page_buildings.blank? && all_buildings.present?
	      per_page_buildings = all_buildings.paginate(:page => page_num, :per_page => PER_PAGE)
	    end
	    
	    
	    final_results.merge!({
	    	all_buildings: buildings_with_featured_listings(all_buildings, featured_listings, top2_featured.length),
	    	map_hash: Building.buildings_json_hash(buildings)
	    })
	    
	    return final_results[:all_buildings], final_results[:map_hash], per_page_buildings
	  end

	  private

	  def buildings_with_featured_listings buildings, featured_listings, top2_featured_count = 0
	  	if featured_listings.present?
	  		buildings = buildings.to_a
	  		featured_listings.each_with_index{|fl, index| buildings.insert(top2_featured_count + index, fl)}
	  	end
	  	return buildings
	  end
	  
	  # putting featured building on top
	  def buildings_with_featured_on_top top_2, per_page
	    top_2.present? ? (top_2 + per_page) : per_page
	  end

	  def non_featured_buildings buildings, top_2
	    buildings = buildings.where.not(id: top_2.map(&:id)) if top_2.present?
	    return Building.sort_buildings(buildings, @sort_by, @filters_params)
	  end

	  def top2_featured_buildings buildings
	    fb_ids = featured_building_ids(buildings.pluck(:id))
	    return [] if fb_ids.blank?
	    buildings.random(fb_ids.shuffle[0..1])
	  end

	  def featured_building_ids ids
	    FeaturedBuilding.active
	    								.where(building_id: ids)
	    								.pluck(:building_id)
	  end
  end
end