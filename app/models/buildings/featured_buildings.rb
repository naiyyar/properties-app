module Buildings
	module FeaturedBuildings
		PER_PAGE = 20
		FEATURED_AGENT_THUMBNAIL_POS = 4

		def with_featured_buildings buildings, featured_listings=nil, agent=nil
	    final_results = { all_buildings: nil, map_hash: nil }
	    @buildings = buildings
	    @featured_listings = featured_listings
	    @agent = agent
	    @buildings = top2_featured + non_featured if top2_featured.present?
	    @per_page_buildings = non_featured.paginate(:page => page_num, :per_page => PER_PAGE)
	    @per_page_buildings = paginate_all_buildings if @per_page_buildings.blank? && all_buildings.present?
	    
	    final_results.merge!({
	    	all_buildings: with_featured_listings_and_agent,
	    	map_hash: Building.buildings_json_hash(@buildings)
	    })
	    
	    return final_results[:all_buildings], final_results[:map_hash], @per_page_buildings
	  end

	  private
	  
	  # when there are only top two featured buildings after filter
	  # then per_page_buildings will be blank due to fitering featured buildings
	  def paginate_all_buildings
	  	all_buildings.paginate(:page => page_num, :per_page => PER_PAGE)
	  end

	  def with_featured_listings_and_agent
	  	return buildings_with_featured_listings if @agent.blank?
	  	insert_at_index = total_featured_property + (FEATURED_AGENT_THUMBNAIL_POS - total_featured_property)
	  	
	  	return buildings_with_featured_listings.to_a.insert(insert_at_index, @agent)
	  end

	  def total_featured_property
	  	(featured_buildings_count + @featured_listings&.size)
	  end

	  def buildings_with_featured_listings 
	  	if @featured_listings.present?
	  		buildings = all_buildings.to_a
	  		@featured_listings.each_with_index{|fl, index| buildings.insert(featured_buildings_count + index, fl)}
	  	end
	  	return buildings
	  end

	  def all_buildings 
	  	@all_buildings ||= buildings_with_featured_on_top
	  end

	  def non_featured
	  	@non_featured ||= non_featured_buildings
	  end

	  def top2_featured
	  	@top2_featured ||= top2_featured_buildings
	  end

	  def featured_buildings_count
	  	@featured_buildings_count ||= top2_featured.length
	  end
	  
	  # putting featured building on top
	  def buildings_with_featured_on_top
	    top2_featured.present? ? (top2_featured + @per_page_buildings) : @per_page_buildings
	  end

	  def non_featured_buildings
	    buildings = @buildings.where.not(id: top2_featured.map(&:id)) if top2_featured.present?
	    return Building.sort_buildings(buildings, @sort_by, @filters_params)
	  end

	  def top2_featured_buildings
	    fb_ids = featured_building_ids(@buildings.pluck(:id))
	    return [] if fb_ids.blank?
	    @buildings.random(fb_ids.shuffle[0..1])
	  end

	  def featured_building_ids ids
	    FeaturedBuilding.active
	    								.where(building_id: ids)
	    								.pluck(:building_id)
	  end
  end
end