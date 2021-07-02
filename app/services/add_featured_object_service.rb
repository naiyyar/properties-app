class AddFeaturedObjectService

	FEATURED_BUILDINGS_CARD_INDEX = 0
	FEATURED_AGENT_CARD_INDEX = 4.freeze

	def initialize per_page_buildings, buildings, search_string='', searched_by=''
		@buildings = buildings # All searched buildings to find the featured buildings
    @buildings_arr = per_page_buildings.to_a
		@search_string = search_string
		@searched_by = searched_by
	end

	def return_buildings
		append_featured_buildings if featured_buildings.present?
		append_featured_listings if featured_listings.present?
		append_featured_agent if featured_agent.present?
		@buildings_arr
	end

	private

  def append_featured_buildings
    featured_buildings.each_with_index do |building, index| 
      @buildings_arr.delete(building) # removing dupicate building if same building is featured building
      @buildings_arr.insert(FEATURED_BUILDINGS_CARD_INDEX + index, building)
    end
  end

  def append_featured_listings
    featured_listings.each_with_index{|fl, index| @buildings_arr.insert(featured_listing_card_index + index, fl)}
  end

  def append_featured_agent
    @buildings_arr.insert(FEATURED_AGENT_CARD_INDEX, featured_agent)
  end

  def featured_buildings
  	@featured_buildings ||= FeaturedObjectService.new(@search_string, @searched_by).get_buildings(@buildings)
  end

  def featured_listings
    return if @search_string.blank?
  	@featured_listings ||= FeaturedObjectService.new(@search_string, @searched_by).get_listings
  end

  def featured_agent
    return if @search_string.blank?
  	@featured_agent ||= FeaturedObjectService.new(@search_string, @searched_by).get_agent
  end

  def featured_listing_card_index
  	FEATURED_BUILDINGS_CARD_INDEX + featured_buildings.size
  end
end