class SearchService
	# constants
	CITY_SEARCH_STRINGS = %w(address no-fee-management-companies-nyc zipcodes).freeze
	
	# Methods
	def initialize params, buildings=nil, search_string=''
		@searched_by = params[:searched_by]
    @search_term = params[:search_term]
    @lat, @lng = params[:latitude], params[:longitude]
    @search_string = search_string
    @buildings = buildings
	end

	def fetch
		buildings = case @searched_by
								when 'zipcode'
									@buildings.buildings_by_zip(@search_string)
								when 'neighborhoods'
									@buildings.buildings_in_neighborhood(@search_string.downcase)
								else
									@buildings.buildings_by_city(@search_string)
								end
		buildings
	end
	
end