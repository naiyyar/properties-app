class FeaturedObjectService

	def initialize search_string, searched_by = ''
		@search_string = search_string
		@searched_by = searched_by
	end

	def get_buildings buildings=nil
  	FeaturedBuilding.active_in_neighborhood(buildings, @search_string)
  end
end