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
	
	def search_link neighborhood, borough
		unless borough == 'BRONX'
			if params[:sort_by].present? or params[:filter].present?
				request.fullpath
			else
				"/search?search_term=#{searchable_text(neighborhood, borough)}&neighborhoods=#{neighborhood}"
			end
		else
			'javascript:void(0)'
		end
	end

	def neighborhood_class
		'pop-neighborhood' if params[:sort_by].present? or params[:filter].present?
	end

	def searched_term
		if @building.present?
			if @building.building_name.present? and @building.building_name != @building.building_street_address
				"#{@building.building_name} - #{@building.street_address}"
			else
				"#{@building.street_address}"
			end
		else
			params['search_term']
		end
	end

	def sort_url(sort_index)
		"/search?search_term=#{params[:search_term]}&neighborhoods=#{params[:neighborhoods]}&sort_by=#{sort_index}"
	end

	def sort_string
		case params[:sort_by]
		when '1'
      'Rating (high to low)'
    when '2'
      'Rating (low to high)'
    when '3'
      'Reviews (high to low)'
    when '4'
      'A - Z'
    when '5'
      'Z - A'
    else
      'Default sort'
    end
	end

	def active index
		params[:sort_by] == index ? 'active' : ''
	end

	def rating_checked val
		params[:filter][:rating].include?(val.to_s) ? 'checked' : '' if params[:filter].present? and params[:filter][:rating].present?
	end

	def type_checked val
		params[:filter][:type].include?(val) ? 'checked' : '' if params[:filter].present? and params[:filter][:type].present?
	end

	def bed_checked val
		params[:filter][:bedrooms].include?(val) ? 'checked' : '' if params[:filter].present? and params[:filter][:bedrooms].present?
	end

	def amen_checked val
		params[:filter][:amenities].include?(val) ? 'checked' : '' if params[:filter].present? and params[:filter][:amenities].present?
	end

	def sort_options
		[['Defaul sort',4],['Rating (high to low)',1],['Rating (low to high)',2],['Reviews (high to low)',3],['A - Z',4],['Z - A',5]]
	end

end