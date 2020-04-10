module HomeHelper

	def hero_image
		if home_page?
    	@hero_image ||= (@mobile_view ? asset_path('hero-mobile.jpg') : asset_path('hero.jpg'))
	  end
  end

	def spv_count_header_style
		if browser.device.mobile? 
			'color: #0075c8; font-size: 21px;'
		else
			'color: #000; font-size: 21px;'
		end
	end
	
	def lower_manhattan_sub_borough
		NYCBorough.lower_manhattan_sub_borough
	end

	def brooklyn_sub_borough
		NYCBorough.brooklyn_sub_borough
	end

	def uptown_sub_borough
		NYCBorough.uptown_sub_borough
	end

	def queens_sub_borough
		NYCBorough.queens_sub_borough
	end

	def bronx_sub_borough
		NYCBorough.bronx_sub_borough
	end

	def brookly_borough
		NYCBorough.brookly_borough
	end

	def queens_borough
		NYCBorough.queens_borough
	end

	def bronx_borough
		NYCBorough.bronx_borough
	end

	def parent_neighborhoods
		NYCBorough.parent_neighborhoods
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

	def search_by_neighborhood_link nb, area
		link_to search_link(nb, area), data: { nbname: nb, st: searchable_text(nb, area) } do
			if @pop_nb_hash[nb].present?
				"#{nb} (<span>#{@pop_nb_hash[nb]}</span>)".html_safe
			else
				"#{nb} (#{parent_neighborhoods_count(nb)})"
			end
		end
	end

	def parent_neighborhoods_count(nb)
		case nb
		when 'Queens' 	then @queens_count
		when 'Brooklyn' then @brooklyn_count
		else
			@bronx_count
		end
	end

	def searched_term
		if @management_company.blank?
			if @building.present?
				if @building.building_name.present? && @building.building_name != @building.building_street_address
					"#{@building.building_name} - #{@building.street_address}"
				else
					"#{@building.street_address}"
				end
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
		if params[:filter].present? && params[:filter][:rating].present?
			params[:filter][:rating].include?(val.to_s) ? 'checked' : ''
		end
	end

	def bed_checked val
		if params[:filter].present? && params[:filter][:bedrooms].present?
			params[:filter][:bedrooms].include?(val) ? 'checked' : ''
		elsif @filters.present? && @filters[:beds].present?
			@filters[:beds].include?(val) ? 'checked' : ''
		end
	end

	def price_checked val
		if params[:filter].present? && params[:filter][:price].present?
			params[:filter][:price].include?(val.to_s) ? 'checked' : ''
		elsif @filters.present? && @filters[:price].present?
			@filters[:price].include?(val) ? 'checked' : ''
		end
	end

	def listing_bed_checked val
		if params[:filter].present? && params[:filter][:listing_bedrooms].present?
			params[:filter][:listing_bedrooms].include?(val.to_s) ? 'checked' : ''
		elsif @filters.present? &&  @filters[:listing_bedrooms].present?
			@filters[:listing_bedrooms].include?(val) ? 'checked' : ''
		end
	end

	def listing_price_box_checked
		'checked' if params[:filter] && params[:filter][:min_price].present?
	end

	def amen_checked val
		if params[:filter].present? && params[:filter][:amenities].present?
			params[:filter][:amenities].include?(val) ? 'checked' : ''
		elsif @filters.present? &&  @filters[:amenities].present?
			@filters[:amenities].include?(val) ? 'checked' : ''
		end
	end

	def amen_locked? val
		if @filters.present? && @filters[:amenities].present?
			@filters[:amenities].include?(val) ? 'disabled' : ''
		else
			''
		end
	end

	def bed_locked? val
		(@filters.present? && @filters[:beds].present? && @filters[:beds].include?(val)) ? 'disabled' : ''
	end

	def price_locked? val
		(@filters.present? && @filters[:price].present? && @filters[:price].include?(val)) ? 'disabled' : ''
	end

	def marker_color price
		case price
		when 1 then '#fee5d9'
		when 2 then '#fcae91'
		when 3 then '#fb6a4a'
		when 4 then '#de2d26'
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
		params[:searched_by] == 'latlng' || session[:view_type] == 'mapView'
	end

	def no_search_result_text
		'<h3>No results matched your search.</h3>'.html_safe +
		 "<p>Though we can't guarentee what you are looking for exists, 
		 we can however guarentee that if you do find an apartment through 
		 	<a href='/'>transparentcity.co</a>, you will save thousands of dollars on broker fees!</p>".html_safe +
		 '<p>Please adjust your filter parameters.</p>'.html_safe
	end

	def manhattan_searches
		@manhattan_searches ||= [ 
			'Manhattan Apartments For Rent', 
			'Luxury Apartments in Manhattan', 
			'Manhattan Apartments For Rent Cheap'
		]
	end

	def nyc_searches
		@nyc_searches ||= [ 
			'Cheap Apartments In NYC', 'Studio Apartments In NYC',
			'Affordable Apartments For Rent In NYC', 
			'One Bedroom Apartments in NYC', 
			'Cheap Studio Apartments in NYC','2 Bedroom Apartments in NYC', 
			'3 Bedroom Apartments For Rent in NYC',
			'Affordable Luxury Apartments In NYC'
		]
	end

	def amenities_searches
		@amenities_searches ||= [
			'Doorman Buildings In NYC', 
			'Pet Friendly Apartments In NYC', 
			'NYC Apartments With Pool', 
			'Walk Up Apartments NYC', 
			'Affordable Doorman Buildings NYC', 
			'NYC Apartments With Gyms'
		]
	end

	def neighborhoods_searches
		@neighborhoods_searches ||= [
			'Studio Apartments in Brooklyn', 
			'Studios For Rent In Queens', 
			'2 Bedroom Apartments in Brookly For Rent', 
			'2 Bedroom Apartments in Queens For Rent', 
			'Luxury Apartments In Upper East Side', 
			'Harlem Studio Apartments',
			'Long Island City Studios', 
			'Upper East Side Studio Apartments', 
			'Upper West Side Studio Apartments',
			"Hell's Kitchen Studios", 'West Village Studios', 
			'2 Bedroom Apartments Upper East Side', 
			"Hell's Kitchen Luxury Rentals",'Midtown Studio Apartments NYC', 
			'Midtown East Luxury Rentals', 'Upper West Side Luxury Rental Buildings',
			'Upper East Side Apartments For Rent With Doorman'
		]
	end

	def col1_popular_searches
		{ 
			'Manhattan' => manhattan_searches, 
			'NYC' 			=> nyc_searches, 
			'Amenities' => amenities_searches 
		}
	end

	def col2_popular_searches
		{ 'Neighborhoods' => neighborhoods_searches }
	end

	def popular_search_link category, link_text
		link_to link_text, "/nyc/#{link_text.downcase.split(' ').join('-')}", class: 'hyper-link'
	end

	def home_quick_links
		[
			{desk_name: 'Midtown Manhattan', 	mob_name: 'Midtown' , url: search_link('Midtown', 				'MANHATTAN')},
			{desk_name: 'Downtown Manhattan',	mob_name: 'Downtown', url: search_link('Lower Manhattan', 'MANHATTAN')},
			{desk_name: 'Upper Manhattan',		mob_name: 'Upper', 		url: search_link('Upper Manhattan', 'MANHATTAN')},
			{desk_name: 'Upper East Side',		mob_name: 'UES', 			url: search_link('Upper East Side', 'MANHATTAN')},
			{desk_name: 'Upper West Side',		mob_name: 'UWS', 			url: search_link('Upper West Side', 'MANHATTAN')},
			{desk_name: 'Brooklyn',						mob_name: 'Brooklyn', url: '/no-fee-apartments-nyc-city/brooklyn-ny'}
		]
	end

	def quick_link_name nb
		browser.device.mobile? ? nb[:mob_name] : nb[:desk_name]
	end

end