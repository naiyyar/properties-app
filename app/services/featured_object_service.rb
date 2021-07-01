class FeaturedObjectService

	def initialize search_string, searched_by = ''
		@search_string = search_string
		@searched_by = searched_by
	end

	def get_buildings buildings=nil
  	FeaturedBuilding.active_in_neighborhood(buildings, @search_string, @searched_by)
  end

  def get_listings
  	FeaturedListing.get_random_objects(@search_string, @searched_by, limit: 2)
  end

  def get_agent
  	FeaturedAgent.get_random_objects(@search_string, @searched_by, limit: 1).first
  end
end