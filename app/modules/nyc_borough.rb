module NYCBorough
	extend self

	def nearby_neighborhoods nb
		case nb
		when 'Lower Manhattan', *lower_manhattan_sub_borough
			sub_neighborhood_hash('Lower Manhattan', lower_manhattan_sub_borough, 'MANHATTAN')
		when 'Midtown', *midtown_manhattan_sub_borough
			sub_neighborhood_hash('Midtown', midtown_manhattan_sub_borough, 'MANHATTAN')
		when 'Upper East Side', *upper_east_side_borough
			sub_neighborhood_hash('Upper East Side', upper_east_side_borough, 'MANHATTAN')
		when 'Upper West Side', *upper_west_side_borough
			sub_neighborhood_hash('Upper West Side', upper_west_side_borough, 'MANHATTAN')
		when 'Upper Manhattan', *upper_manhattan_sub_borough
			sub_neighborhood_hash('Upper Manhattan', upper_manhattan_sub_borough, 'MANHATTAN')
		when 'Brooklyn', *brookly_borough
			sub_neighborhood_hash('Brooklyn', brookly_borough, 'Brooklyn')
		when 'Queens', *queens_borough
			sub_neighborhood_hash('Queens', queens_borough, 'Queens')
		when 'Bronx', *bronx_borough
			sub_neighborhood_hash('Bronx', bronx_borough, 'Bronx')
		end
	end

	def sub_neighborhood_hash parent_neighborhood, hoods, area
		{ parent_neighborhood => { hoods: hoods, area: area } }
	end
	
	def lower_manhattan_sub_borough
		[
			'Battery Park City',
			'Bowery',
			'East Village',
			'Financial District',
			'Greenwich Village',
			'Lower East Side',
			'Nolita',
			'SoHo',
			'Tribeca',
			'West Village'
		]
	end

	def midtown_manhattan_sub_borough
		[
			'Chelsea',
			'Flatiron Distric',
			'Gramercy Park',
			"Hell's Kitchen",
			'Kips Bay',
			'Midtown East',
			'Midtown South',
			'Sutton Place',
			'Midtown West ',
			'Murray Hill',
			'Roosevelt Island'
		]
	end

	def upper_manhattan_sub_borough
		[
			'East Harlem',
			'Harlem',
			'South Harlem',
			'Central Harlem',
			'Hamilton Heights',
			'Morningside Heights',
			'Washington Heights',
			'Hudson Heights'
		]
	end

	def brooklyn_sub_borough
		[
		  'Brooklyn Heights',
      'Bushwick',
      'Clinton Hill',
      'Crown Heights',
      'Downtown Brooklyn',
      'Dumbo',
      'Fort Greene',
      'Greenpoint',
      'Park Slope',
      'Sheepshead Bay',
      'Williamsburg'
		]
	end

	def uptown_sub_borough
		@uptown_sub_borough ||= ['Upper East Side', 'Upper West Side']
	end

	def upper_east_side_borough
		[ 'Carnegie Hill','Lenox Hill', 'Yorkville']
	end

	def upper_west_side_borough
		[ 'Lincoln Square', 'Manhattan Valley']
	end

	def queens_sub_borough
		[
			'Astoria',
	    'Corona',
	    'Flushing',
	    'Forest Hills',
	    'Kew Gardens',
	    'Long Island City',
	    'Rego Park',
	    'Ridgewood'
	  ]
	end

	def bronx_sub_borough
		[
			'East Bronx',
			'University Heights', 
			'Morris Heights', 
			'Riverdale'
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
			'Prospect Lefferts Gardens',
			'Williamsburg'
		]
	end

	def queens_borough
		[	'Astoria',
			'Arverne',
			'Auburndale',
			'Bayside',
			'Briarwood',
			'Corona',
			'Elmhurst',
			'Far Rockaway',
			'Flushing',
			'Forest Hills',
			'Jackson Heights',
			'Jamaica',
			'Kew Gardens',
			'Long Island City',
			'Queens Village',
			'Rego Park',
			'Ridgewood',
			'Richmond Hill',
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
		 'East Bronx',
		 'Fordham',
		 'Kingsbridge',
		 'Mott Haven',
		 'Morris Heights',
		 'Riverdale',
		 'Spuyten Duyvil',
		 'Tremont',
		 'University Heights',
		 'Fordham Manor'
		]
	end

	def parent_neighborhoods
		@parent_neighborhoods ||= [ 'Lower Manhattan',
																'Midtown', 
																'Upper Manhattan',
																'Queens','Bronx'
															]
	end
end