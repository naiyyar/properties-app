module NYCBorough
	extend self
	
	def lower_manhattan_sub_borough
		@lower_manhattan_sub_borough ||= [
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
			'Sutton Place',
			'Midtown West ',
			'Murray Hill',
			'Roosevelt Island'
		]
	end

	def upper_manhattan_sub_borough
		@upper_manhattan_sub_borough ||= [
			'East Harlem',
			'Harlem ',
			'South Harlem',
			'Central Harlem',
			'Hamilton Heights',
			'Morningside Heights',
			'Washington Heights',
			'Hudson Heights'
		]
	end

	def brooklyn_sub_borough
		@brooklyn_sub_borough ||= ['Brooklyn Heights',
															 'Bushwick','Clinton Hill',
															 'Downtown Brooklyn','Dumbo','Fort Greene',
															 'Gravesend','Greenpoint'
															]
	end

	def uptown_sub_borough
		@uptown_sub_borough ||= ['Upper East Side', 'Upper West Side']
	end

	def queens_sub_borough
		@queens_sub_borough ||= [
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
		@bronx_sub_borough ||= ['East Bronx',
														'University Heights', 
														'Morris Heights', 
														'Riverdale'
													]
	end

	def brookly_borough
		@brookly_borough ||= [ 
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
		@queens_borough ||= [	'Astoria',
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
		@bronx_borough ||= [
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
												 'University Heights'
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