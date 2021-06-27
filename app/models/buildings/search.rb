module Buildings
	class Search
		# constants
		CITY_SEARCH_STRINGS = %w(address no-fee-management-companies-nyc zipcodes)

		# modules
		include NYCBorough
		
		# Methods
		def initialize params, buildings=nil, search_string=''
			@sort_by = params[:sort_by]
			@filters_params = params[:filter]
			@searched_by = params[:searched_by]
	    @search_term = params[:search_term]
	    @lat, @lng = params[:latitude], params[:longitude]
	    @zoomlevel = params[:zoomlevel]
	    @search_string = search_string
	    @buildings = buildings
	    @results = { filters: nil, zoom: 14, boundary_coords: [] }
		end

		def fetch
			@results[:buildings] = unless @lat.present? && @lng.present?
																unless @search_string == 'New York'
																	self.searched_buildings
																else
																	@buildings.buildings_in_city(@search_string)
																end
															else
																@buildings.redo_search_buildings([@lat.to_f, @lng.to_f], @zoomlevel)
															end
			@results[:zoom] = set_zoom
			@results[:buildings] = Building.sort_buildings(properties, @sort_by, @filters_params)
			return @results
		end

		# By zip, neighborhood, popularSearch and city
		def searched_buildings
			case @searched_by
			when 'zipcode'
				buildings = @buildings.buildings_by_zip(@search_string)
				@results[:boundary_coords] << Gcoordinate.zip_boundary_coordinates(@search_string)
			when 'no-fee-apartments-nyc-neighborhoods'
				buildings = @buildings.buildings_in_neighborhood(@search_string.downcase)
			when 'nyc'
				buildings, @results[:filters] = Building.buildings_by_popular_search(@search_term, @buildings)
				@results[:zoom] = 12
			else
				buildings = self.search_by_city_or_nb
				@results[:zoom] = 12
			end
			
			return buildings
		end

		def search_by_city_or_nb
			@buildings.buildings_by_city_or_nb(@search_string, sub_borough)
		end

		private

		def properties
			return @results[:buildings] unless @filters_params.present? 
			@buildings.filtered_buildings(@results[:buildings], @filters_params)
		end

		def sub_borough
			return if CITY_SEARCH_STRINGS.include?(@searched_by)
      sub_borough_hash[@search_string]
		end

		def sub_borough_hash
			{
				'Queens' 		=> queens_borough,
				'Brooklyn' 	=> brooklyn_sub_borough,
				'Bronx' 		=> bronx_sub_borough
			}
		end

		def set_zoom
			if @lat.present? && @lng.present?
				@zoomlevel || (@results[:buildings]&.length.to_i > 90 ? 15 : 14)
			else
				@search_string == 'New York' ? 12 : 14
			end
		end
	end
end