module Buildings
	class Search
		# constants
		CITY_SEARCH_STRINGS = %w(address no-fee-management-companies-nyc zipcodes)

		# modules
		include NYCBorough
		include Buildings::FeaturedBuildings
		
		# Methods
		def initialize params, buildings=nil, search_string=''
			@page 										 = params[:page]
			@sort_by 									 = params[:sort_by]
			@filters_params 					 = params[:filter]
			@search_string 						 = search_string
			@searched_by               = params[:searched_by]
	    @search_term               = params[:search_term]
	    @buildings 								 = buildings
	    @results                   = {}
	    @results[:filters]         = nil
	    @results[:zoom]            = 14
	    @results[:boundary_coords] = []
	    @lat 											 = params[:latitude]
	    @lng 											 = params[:longitude]
	    @zoomlevel 								 = params[:zoomlevel]
		end

		def fetch
			@results[:zoom]      = set_zoom
			@results[:buildings] = unless @lat.present? && @lng.present?
																unless @search_string == 'New York'
																	self.searched_buildings
																else
																	@buildings.buildings_in_city(@search_string)
																end
															else
																@buildings.redo_search_buildings([@lat.to_f, @lng.to_f], @zoomlevel)
															end
															
			@results[:buildings] = @buildings.filtered_buildings(@results[:buildings], @filters_params) if @filters_params.present?
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
				buildings 			= self.search_by_city_or_nb
				@results[:zoom] = 12
			end
			
			return buildings
		end

		def search_by_city_or_nb
			@buildings.cached_buildings_by_city_or_nb(@search_string, sub_borough)
		end

		private

		def sub_borough
			unless CITY_SEARCH_STRINGS.include?(@searched_by)
				@sub_borough = {
					'Queens' 		=> queens_borough,
					'Brooklyn' 	=> brooklyn_sub_borough,
					'Bronx' 		=> bronx_sub_borough
				}
       	return @sub_borough[@search_string]
      else
      	nil
      end
		end

		def set_zoom
			if @lat.present? && @lng.present?
				@zoomlevel || (@results[:buildings]&.length.to_i > 90 ? 15 : 14)
			else
				@search_string == 'New York' ? 12 : 14
			end
		end

	  def page_num
			@page.present? ? @page.to_i : 1
		end
	end
end