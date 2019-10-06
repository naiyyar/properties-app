module HomeHelper
	def manhattan_neighborhoods
		{ 
			'MANHATTAN' => manhattan_borough,
			'BROOKLYN' => brookly_borough,
			'QUEENS' => queens_borough,
			'BRONX' => bronx_borough
		}
	end

	def ny_cities
		['MANHATTAN', 'BROOKLYN','QUEENS','BRONX']
	end

	def lower_manhattan_sub_borough
		[
			'Battery Park City',
			'East Village',
			'Financial District',
			'Greenwich Village',
			'West Village',
			'Lower East Side',
			'SoHo',
			'Tribeca'
		]
	end

	def midtown_sub_borough
		[
			'Chelsea',
			'Gramercy Park',
			"Hell's Kitchen",
			'Kips Bay',
			'Midtown East',
			'Sutton Place',
			'Murray Hill',
			'Roosevelt Island'
		]
	end

	def upper_manhattan_sub_borough
		[
			'East Harlem',
			'Hudson Heights',
			'Washington Heights',
			'Harlem',
			'Morningside Heights',
		]
	end

	def brooklyn_sub_borough
		[
			'Brooklyn Heights',
			'Bushwick',
			'Clinton Hill',
			'Downtown Brooklyn',
			'Dumbo',
			'Fort Greene',
			'Gravesend',
			'Greenpoint'
		]
	end

	def uptown_sub_borough
		[
			'Upper East Side',
			#'Carnegie Hill',
			#'Lenox Hill',
			#'Yorkville',
			'Upper West Side',
			#'Lincoln Square'
		]
	end

	def queens_sub_borough
		[
			'Astoria',
	    'Corona',
	    'Flushing',
	    'Forest Hills',
	    'Kew Gardens',
	    'Long Island City',
	    'Rego Park'
	  ]
	end

	def bronx_sub_borough
		[
			'East Bronx',
			'University Heights'
		]
	end

	#using for neighborhood guides
	def manhattan_borough
		[
			'Harlem',
			'Chelsea',
			'East Harlem',
			'East Village',
			'Financial District',
			# 'Flatiron District',
			'Gramercy Park',
			'Greenwich Village',
			'Hamilton Heights',
			"Hell's Kitchen",
			'Kips Bay',
			'Lower East Side',
			'Midtown East',
			'Murray Hill',
			'SoHo',
			'Tribeca',
			'Upper East Side',
			'Upper West Side',
			'Washington Heights'
		]
	end

	def brookly_borough
		[ 
			'Bedford-Stuyvesant',
			'Brooklyn Heights',
			'Bushwick',
			'Carroll Gardens',
			'Clinton Hill',
			'Crown Heights',
			'Downtown Brooklyn',
			'Flatbush - Ditmas Park',
			'Fort Greene',
			'Greenpoint',
			'Park Slope',
			'Prospect Heights',
			'Prospect Lefferts Gardens',
			'Williamsburg'
		]
	end

	def queens_borough
	 [	'Astoria',
			'Corona',
			'Elmhurst',
			'Flushing',
			'Forest Hills',
			'Jackson Heights',
			'Jamaica',
			'Kew Gardens',
			'Long Island City',
			'Rego Park',
			'Sunnyside',
			'Woodside'
		]
	end

	def bronx_borough
		[
		 'Belmont',
		 'Bronxdale',
		 'Bronxwood',
		 'Concourse',
		 'Fordham',
		 'Kingsbridge',
		 'Mott Haven',
		 'Riverdale',
		 'Spuyten Duyvil',
		 'Tremont',
		 'University Heights'
		]
	end

	def searchable_text neighborhood, borough
		if borough == 'MANHATTAN'
			"#{neighborhood}, New York, NY"
		elsif borough == 'QUEENS'
			"#{neighborhood}, #{neighborhood}, NY"
		else
			"#{neighborhood}, #{borough.capitalize}, NY"
		end
	end
	
	#To retain filters when switching neighborhoods
	#/no-fee-apartments-nyc-neighborhoods/lower-manhattan-newyork?sort_by=4&filter%5Bprice%5D%5B%5D=2&searched_by=no-fee-apartments-nyc-neighborhoods
	def search_link neighborhood, borough
		unless borough == 'BRONX'
			borough = (borough == 'MANHATTAN' ? 'newyork' : borough.downcase.gsub(' ', '-'))
			search_term = "#{neighborhood.downcase.gsub(' ', '-')}-#{borough}"
			search_url = "/no-fee-apartments-nyc-neighborhoods/#{search_term}"
			if params[:sort_by].present? and params[:filter].present?
				"#{search_url}?sort_by=#{params[:sort_by]}&#{filter_params}"
			elsif params[:sort_by].present?
				"#{search_url}?sort_by=#{params[:sort_by]}"
			elsif params[:filter].present?
				"#{search_url}"
			else
				filter_params.present? ? "#{search_url}?#{filter_params}" : "#{search_url}"
			end
		else
			'javascript:void(0)'
		end
	end

	def filter_params
		params[:filter].present? ? params[:filter].to_query('filter') : nil
	end

	#on show page neighborhoods
	def borough_search_link borough
		if queens_borough.include?(borough)
      search_link(borough, 'QUEENS')
    elsif brookly_borough.include?(borough)
      search_link(borough, 'BROOKLYN')
    elsif brookly_borough.include?(borough)
      search_link(borough, 'MANHATTAN')
    else
      search_link(borough, 'MANHATTAN')
    end
	end

	def parent_neighborhoods
		[	
			'Lower Manhattan',
			'Midtown',
			'Upper Manhattan',
			'Queens',
			'Bronx'
		]
	end

	def search_by_neighborhood_link nb, area
		if @show_nb_counts
			link_to search_link(nb, area), data: { nbname: nb, st: searchable_text(nb, area) } do
				if @pop_nb_hash[nb].present?
					"#{nb} (<span>#{@pop_nb_hash[nb]}</span>)".html_safe
				else
					"#{nb} (#{parent_neighborhoods_count(nb)})"
				end
			end
		end
	end

	def parent_neighborhoods_count(nb)
		case nb
		when 'Queens'
			@queens_count
		when 'Brooklyn'
			@brooklyn_count
		else
			@bronx_count
		end
	end

	def searched_term
		if @management_company.blank?
			if @building.present?
				if @building.building_name.present? and @building.building_name != @building.building_street_address
					"#{@building.building_name} - #{@building.street_address}"
				else
					"#{@building.street_address}"
				end
			#elsif custom_search?
			#	'Custom'
			else
				@search_input_value
			end
		else
			"#{@management_company.name}" 
		end
	end

	def active index
		params[:sort_by] == index ? 'active' : ''
	end

	def rating_checked val
		params[:filter][:rating].include?(val.to_s) ? 'checked' : '' if params[:filter].present? and params[:filter][:rating].present?
	end

	# def type_checked val
	# 	params[:filter][:type].include?(val) ? 'checked' : '' if params[:filter].present? and params[:filter][:type].present?
	# end

	def bed_checked val
		if params[:filter].present? and params[:filter][:bedrooms].present?
			params[:filter][:bedrooms].include?(val) ? 'checked' : ''
		elsif @filters.present? and @filters[:beds].present?
			@filters[:beds].include?(val) ? 'checked' : ''
		end
	end

	def price_checked val
		if params[:filter].present? and params[:filter][:price].present?
			params[:filter][:price].include?(val.to_s) ? 'checked' : ''
		elsif @filters.present? and @filters[:price].present?
			@filters[:price].include?(val) ? 'checked' : ''
		end
	end

	def listing_bed_checked val
		if params[:filter].present? and params[:filter][:listing_bedrooms].present?
			params[:filter][:listing_bedrooms].include?(val.to_s) ? 'checked' : ''
		elsif @filters.present? and @filters[:listing_bedrooms].present?
			@filters[:listing_bedrooms].include?(val) ? 'checked' : ''
		end
	end

	def listing_price_box_checked
		'checked' if params[:filter] && params[:filter][:min_price].present?
	end

	def amen_checked val
		if params[:filter].present? and params[:filter][:amenities].present?
			params[:filter][:amenities].include?(val) ? 'checked' : ''
		elsif @filters.present? and @filters[:amenities].present?
			@filters[:amenities].include?(val) ? 'checked' : ''
		end
	end

	def amen_locked? val
		if @filters.present? and @filters[:amenities].present?
			@filters[:amenities].include?(val) ? 'disabled' : ''
		else
			''
		end
	end

	def bed_locked? val
		(@filters.present? and @filters[:beds].present? and @filters[:beds].include?(val)) ? 'disabled' : ''
	end

	def price_locked? val
		(@filters.present? and @filters[:price].present? and @filters[:price].include?(val)) ? 'disabled' : ''
	end

	# def sort_options
	# 	[['Defaul sort',4],
	# 		['Rating (high to low)',1],
	# 		['Rating (low to high)',2],
	# 		['Reviews (high to low)',3],
	# 		['A - Z',4],
	# 		['Z - A',5]]
	# end

	def marker_color price
		case price
		when 1
			'#fee5d9'
		when 2
			'#fcae91'
		when 3
			'#fb6a4a'
		when 4
			'#de2d26'
		else
			'#a50f15'
		end
	end

	#redo search
	def custom_search?
		#params[:latitude].present? && params[:longitude].present?
		#current location search also have lat and long
		#searching on mobile redirecting to map view instad of list view
		#returning to map view if user is searching or filtering from inside the map view
		params[:searched_by] == 'latlng' or session[:view_type] == 'mapView'
	end

	def no_search_result_text
		txt = '<h3>No results matched your search.</h3>' +
		"<p>Though we can't guarentee what you are looking for exists, we can however guarentee that if you do find an apartment through <a href='/'>transparentcity.co</a>, you will save thousands of dollars on broker fees!</p>" +
		'<p>Please adjust your filter parameters.</p>'
		txt.html_safe
	end

	def manhattan_searches
		['Manhattan Apartments For Rent', 'Luxury Apartments in Manhattan', 'Manhattan Apartments For Rent Cheap']
	end

	def nyc_searches
		[ 
			'Cheap Apartments In NYC', 'Studio Apartments In NYC','Affordable Apartments For Rent In NYC', 'One Bedroom Apartments in NYC', 
			'Cheap Studio Apartments in NYC','2 Bedroom Apartments in NYC', '3 Bedroom Apartments For Rent in NYC','Affordable Luxury Apartments In NYC'
		]
	end

	def amenities_searches
		['Doorman Buildings In NYC', 'Pet Friendly Apartments In NYC', 'NYC Apartments With Pool', 'Walk Up Apartments NYC', 
			'Affordable Doorman Buildings NYC', 'NYC Apartments With Gyms']
	end

	def neighborhoods_searches
		[
			'Studio Apartments in Brooklyn', 'Studios For Rent In Queens', '2 Bedroom Apartments in Brookly For Rent', 
			'2 Bedroom Apartments in Queens For Rent', 'Luxury Apartments In Upper East Side', 'Harlem Studio Apartments',
			'Long Island City Studios', 'Upper East Side Studio Apartments', 'Upper West Side Studio Apartments',
			"Hell's Kitchen Studios", 'West Village Studios', '2 Bedroom Apartments Upper East Side', "Hell's Kitchen Luxury Rentals",
			'Midtown Studio Apartments NYC', 'Midtown East Luxury Rentals', 'Upper West Side Luxury Rental Buildings',
			'Upper East Side Apartments For Rent With Doorman'
		]
	end

	def col1_popular_searches
		{
			'Manhattan' => manhattan_searches,
			'NYC' => nyc_searches,
			'Amenities' => amenities_searches,
		}
	end

	def col2_popular_searches
		{
			'Neighborhoods' => neighborhoods_searches,
		}
	end

	def popular_search_link category, link_text
		link_to link_text, "/nyc/#{link_text.downcase.split(' ').join('-')}", class: 'hyper-link'
	end

end