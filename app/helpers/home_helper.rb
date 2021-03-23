module HomeHelper

	def self_service_btn_link type
		unless current_user
      '/users/sign_up'
    else
    	case type
    	when 'agents'
    		agenttools_user_path(current_user, type: 'featured')
    	when 'property-manager'
    		managertools_user_path(current_user, type: 'featured')
    	when 'for-rent-by-owner'
    		frbotools_user_path(current_user, type: 'featured')
     	end
    end
	end

	def hero_image
		if home_page?
    	@mobile_view ? asset_path('hero-mobile.jpg') : asset_path('hero.jpg')
	  end
  end

  def search_input_placeholders
  	'Neighborhood, ZipCode, Address, Building, Management Company'
  end

  def split_view_header
  	return popular_search_string if params[:searched_by] == 'nyc'
		"#{@searched_neighborhoods} Apartments For Rent" 
	end

	def popular_search_string
		@searched_neighborhoods.gsub('Nyc', 'NYC')
	end

	def spv_count_header_style
		if browser.device.mobile? 
			'color: #0075c8; font-size: 21px;'
		else
			'color: #000; font-size: 21px;margin: 0px;'
		end
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

	# on show page neighborhoods
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
				if @building.building_name? && @building.building_name != @building.building_street_address
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

	# redo search
	# params[:latitude].present? && params[:longitude].present?
	# current location search also have lat and long
	# searching on mobile redirecting to map view instad of list view
	# returning to map view if user is searching or filtering from inside the map view
	def custom_search?
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
			'Manhattan Apartments For Rent Cheap'
		]
	end

	def nyc_searches
		@nyc_searches ||= [ 
			'CoLiving Spaces In NYC For Rent',
			'Studio Apartments In NYC For Rent',
			'Affordable Apartments For Rent In NYC',
			'Cheap Apartments In NYC For Rent',
			'2 Bedroom Apartments in NYC', 
			'3 Bedroom Apartments For Rent in NYC',
			'One Bedroom Apartments in NYC For Rent', 
			'Cheap Studio Apartments in NYC For Rent',
		]
	end

	def amenities_searches
		@amenities_searches ||= [
			'Pet Friendly Apartments In NYC', 
			'Walk Up Apartments NYC', 
			'Affordable Doorman Buildings NYC', 
			'NYC Apartments With Gyms'
		]
	end

	def neighborhoods_searches
		@neighborhoods_searches ||= [
			'Studio Apartments in Brooklyn For Rent', 
			'Studios For Rent In Queens', 
			'2 Bedroom Apartments in Brooklyn For Rent', 
			'2 Bedroom Apartments in Queens For Rent', 
			'Harlem Studio Apartments','Long Island City Studios', 
			'Upper East Side Studio Apartments', 
			'Upper West Side Studio Apartments',
			"Hell's Kitchen Studios", 'West Village Studios', 
			'2 Bedroom Apartments Upper East Side',
		]
	end

	def luxury_searches
		@luxury_searches ||= [
			'Penthouses For Rent In NYC',
			'Luxury Apartments For Rent In NYC',
			'Affordable Luxury Apartments In NYC',
			'Brooklyn Luxury Rentals',
			'Luxury Apartments in Manhattan For Rent'
		]
	end

	def luxury_neighborhoods
		@luxury_neighborhoods ||= [
			'Battery Park City Luxury Rentals','Chelsea Luxury Rentals',
			'Downtown Brooklyn Luxury Rentals','East Harlem Luxury Rentals',
			'East Village Luxury Rentals','Financial District Luxury Rentals',
			'Gramercy Luxury Rentals','Harlem Luxury Rentals',
			"Hell's Kitchen Luxury Rentals",'Kips Bay Luxury Rentals',
			'Long Island City Luxury Rentals','Midtown East Luxury Rentals',
			'Midtown West Luxury Rentals','Murray Hill Luxury Rentals',
			'Roosevelt Island Luxury Rentals','Tribeca Luxury Rentals',
			'Upper East Side Luxury Rentals','Upper West Side Luxury Rentals',
			'West Village Luxury Rentals','Williamsburg Luxury Rentals'
		]
	end

	def col1_popular_searches
		{ 
			'Manhattan' 		=> manhattan_searches, 
			'NYC' 					=> nyc_searches, 
			'Amenities' 		=> amenities_searches,
			'Neighborhoods' => neighborhoods_searches
		}
	end

	def col2_popular_searches
		{ 
			'Luxury' 							 => luxury_searches,
		 	'Luxury Neighborhoods' => luxury_neighborhoods
		}
	end

	def popular_search_url link_text
		search_string = link_text.downcase.split(' ').join('-')
		url = "/nyc/#{search_string}"
		return url unless search_string == 'penthouses-for-rent-in-nyc'
		"#{url}?sort_by=0&filter%5Blistings%5D%5Bprice%5D%5B%5D=on&searched_by=nyc&filter%5Blistings%5D%5Bmin_price%5D=#{Building::PENTHOUSES_MIN_PRICE}&filter%5Blistings%5D%5Bmax_price%5D=15500%2B"
	end

	def popular_search_link category, link_text
		link_to link_text, popular_search_url(link_text), class: 'hyper-link'
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