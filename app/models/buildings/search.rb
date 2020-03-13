module Buildings
	class Search
		# constants
		CITY_SEARCH_STRINGS = ['address', 'no-fee-management-companies-nyc', 'zipcodes']

		# modules
		include NYCBorough
		
		# Methods
		def initialize params, formatted_search_string
			@sort_by 									 = params[:sort_by]
			@filters 									 = params[:filter]
			@search_string 						 = formatted_search_string
			@searched_by               = params[:searched_by]
	    @search_term               = params[:search_term]
	    @results                   = {}
	    @results[:filters]         = nil
	    @results[:zoom]            = 14
	    @results[:boundary_coords] = []
	    @lat 											 = params[:latitude]
	    @lng 											 = params[:longitude]
	    @zoomlevel 								 = params[:zoomlevel]

	    @sub_borough             	 = {}
	    unless CITY_SEARCH_STRINGS.include?(@searched_by)
        @sub_borough['Queens']   = queens_sub_borough
        @sub_borough['Brooklyn'] = brooklyn_sub_borough
        @sub_borough['Bronx']    = bronx_sub_borough
      end
		end

		def call
			@results[:zoom]      = set_zoom
			@results[:buildings] = unless @lat.present? && @lng.present?
																unless @search_string == 'New York'
																	self.searched_buildings
																else
																	Building.buildings_in_city(@search_string)
																end
															else
																Building.redo_search_buildings(@lat, @lng, @zoomlevel)
															end
			@results[:buildings] = @results[:buildings].updated_recently if no_sorting?
			if @filters.present?
				@results[:buildings] = Building.filtered_buildings(@results[:buildings], @filters)
			end
			if @results[:buildings].present? && @sort_by != '0'
				@results[:buildings] = Building.sort_buildings(@results[:buildings], @sort_by)
			end
			return @results
		end

		# By zip, neighborhood, popularSearch and city
		def searched_buildings
			case @searched_by
			when 'zipcode'
				buildings = Building.buildings_by_zip(@search_string)
				@results[:boundary_coords] << Gcoordinate.zip_boundary_coordinates(@search_string)
			when 'no-fee-apartments-nyc-neighborhoods'
				buildings = Building.buildings_in_neighborhood(@search_string)
			when 'nyc'
				buildings 					= Building.buildings_by_popular_search(@search_term)[0]
				@results[:filters]  = Building.buildings_by_popular_search(@search_term)[1]
				@results[:zoom] 		= 12
			else
				buildings = self.search_by_city_or_nb
				@results[:zoom] 		= 12
			end
			return buildings
		end

		def search_by_city_or_nb
			Building.cached_buildings_by_city_or_nb(@search_string, @sub_borough[@search_string])
		end

		private

		def set_zoom
			if @lat.present? && @lng.present?
				@zoomlevel || (@results[:buildings].length > 90 ? 15 : 14)
			else
				@search_string == 'New York' ? 12 : 14
			end
		end

		def no_sorting?
			@sort_by.blank? || @sort_by == '0'
		end

	end
end