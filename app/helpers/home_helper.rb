module HomeHelper
	def manhattan_neighborhoods
		{ 
			'MANHATTAN' => manhattan_borough,
			'BROOKLYN' => brookly_borough,
			'QUEENS' => queens_borough,
			'BRONX' => bronx_borough
		}
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
			'Flatbush',
			'Fort Greene',
			'Greenpoint',
			'Park Slope',
			'Prospect Heights',
			'Prospect Lefferts Garden',
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
		else
			"#{neighborhood}, #{borough.capitalize}, NY"
		end
	end

end