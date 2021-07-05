class AddFeaturedObjectService

	def initialize per_page_buildings, buildings, search_string='', searched_by=''
		@buildings = buildings # All searched buildings to find the featured buildings
    @buildings_arr = per_page_buildings.to_a
		@search_string = search_string
		@searched_by = searched_by
	end

	def return_buildings
		append_featured_buildings if featured_buildings.present?
		@buildings_arr
	end

	private

  def append_featured_buildings
    featured_buildings.each_with_index do |building, index| 
      @buildings_arr.delete(building) # removing dupicate building if same building is featured building
      @buildings_arr.insert(index, building)
    end
  end

  def featured_buildings
  	@featured_buildings ||= FeaturedObjectService.new(@search_string, @searched_by)
                                                 .get_buildings(@buildings)
  end
end