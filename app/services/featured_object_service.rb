class FeaturedObjectService

	def initialize search_string, searched_by = ''
		@search_string = search_string
		@searched_by = searched_by
	end

	def get_buildings buildings
  	FeaturedBuilding.active_in_neighborhood(@search_string, buildings)
  end

  def get_listings
  	FeaturedListing.get_random_objects(@search_string, @searched_by, limit: 2)
  end

  def get_agent
  	FeaturedAgent.get_random_objects(@search_string, @searched_by, limit: 1).first
  end
end