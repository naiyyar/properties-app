class AddFeaturedObjectService

	FEATURED_BUILDINGS_CARD_INDEX = 0
	FEATURED_AGENT_CARD_INDEX = 4.freeze

	def initialize buildings, search_string, searched_by = ''
		@buildings = buildings.to_a
		@search_string = search_string
		@searched_by = searched_by
	end

	def return_buildings
		append_featured_buildings if featured_buildings.present?
		append_featured_listings if featured_listings.present?
		append_featured_agent if featured_agent.present?
		@buildings
	end

	private

  def append_featured_buildings
    featured_buildings.includes(:building).each_with_index{|fb, index| @buildings.insert(FEATURED_BUILDINGS_CARD_INDEX + index, fb.building)}
  end

  def append_featured_listings
    featured_listings.each_with_index{|fl, index| @buildings.insert(featured_listing_card_index + index, fl)}
  end

  def append_featured_agent
    @buildings.insert(FEATURED_AGENT_CARD_INDEX, featured_agent)
  end

  def featured_buildings
  	@featured_buildings ||= FeaturedObjectService.new(@search_string).get_buildings
  end

  def featured_listings
  	@featured_listings ||= FeaturedObjectService.new(@search_string, @searched_by).get_listings
  end

  def featured_agent
  	@featured_agent ||= FeaturedObjectService.new(@search_string, @searched_by).get_agent
  end

  def featured_listing_card_index
  	FEATURED_BUILDINGS_CARD_INDEX + featured_buildings.size
  end
end