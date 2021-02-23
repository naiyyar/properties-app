module Search
	module PopularSearches
		QUEENS_CITIES 				  = [ 'Queens','Astoria','Corona','Flushing','Forest Hills',
															  'Kew Gardens','Long Island City','Rego Park']
		LUXURY_APTS_AMENITIES   = %w(doorman elevator)
		LUXURY_APTS_PRICES 			= [3,4]
		AFFORDABLE_APTS_PRICES  = [1,2]
		AFFORDABLE_LUXURY_APTS_PRICES  = [2]
		STUDIOS 								= ['0']
		PET_AMENITITES = %w(pets_allowed_cats pets_allowed_dogs)
		LUXURY_APTS_NEIGHBORHOODS = [
			'Battery Park City',
			'Chelsea',
			'Downtown Brooklyn',
			'East Harlem',
			'East Village',
			'Financial District',
			'Gramercy',
			'Harlem',
			"Hell's Kitchen",
			'Kips Bay',
			'Long Island City',
			'Midtown East',
			'Midtown West',
			'Murray Hill',
			'Roosevelt Island',
			'Tribeca',
			'Upper East Side',
			'Upper West Side',
			'West Village',
			'Williamsburg'
		]
		
		def buildings_by_popular_search search_term, buildings
			filters = {}
			search_nb = search_term.split('-')[0..-3].join(' ')
			
			if LUXURY_APTS_NEIGHBORHOODS.include?(search_nb.titleize)
				buildings = buildings_in_neighborhood(search_nb).luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			else
				@buildings = buildings
				case search_term
				when 'manhattan-apartments-for-rent'
					buildings = manhattan_buildings
					# No use of filters hash here. It's only to fix the SEO tab title
					filters[:amenities] = ['man']
				when 'manhattan-apartments-for-rent-cheap'
					buildings 			= manhattan_buildings.where(price: AFFORDABLE_APTS_PRICES)
					filters[:price] = AFFORDABLE_APTS_PRICES
				when 'coliving-spaces-in-nyc-for-rent'
					buildings 			= @buildings.with_bed([Building::COLIVING_NUM.to_s])
					filters[:beds] 	= [Building::COLIVING_NUM]
				when 'studio-apartments-in-nyc-for-rent'
					buildings 			= @buildings.with_bed(STUDIOS)
					filters[:beds] 	= STUDIOS
				when 'affordable-apartments-for-rent-in-nyc'
					buildings 			= @buildings.where(price: AFFORDABLE_APTS_PRICES)
					filters[:price] = AFFORDABLE_APTS_PRICES
				when 'cheap-apartments-in-nyc-for-rent'
					buildings 			= @buildings.where(price: 1)
					filters[:price] = [1]
				when '2-bedroom-apartments-in-nyc'
					buildings 			= @buildings.with_bed(['2'])
					filters[:beds] 	= ['2']
				when '3-bedroom-apartments-for-rent-in-nyc'
					buildings 			= @buildings.with_bed(['3'])
					filters[:beds] 	= ['3']
				when 'one-bedroom-apartments-in-nyc-for-rent'
					buildings 			= @buildings.with_bed(['1'])
					filters[:beds] 	= ['1']
				when 'cheap-studio-apartments-in-nyc-for-rent'
					buildings 			= @buildings.with_bed(STUDIOS).where(price: 1)
					filters[:price] = [1]
					filters[:beds] 	= STUDIOS
				# amenities
				when 'pet-friendly-apartments-in-nyc'
					buildings 					= @buildings.with_amenities(PET_AMENITITES)
					filters[:amenities] = PET_AMENITITES
				when 'nyc-apartments-with-pool'
					buildings 					= @buildings.with_amenities(['swimming_pool'])
					filters[:amenities] = ['swimming_pool']
				when 'walk-up-apartments-nyc'
					buildings 					= @buildings.with_amenities(['walk_up'])
					filters[:amenities] = ['walk_up']
				when 'affordable-doorman-buildings-nyc'
					buildings 					= @buildings.where(price: AFFORDABLE_APTS_PRICES).with_amenities(['doorman'])
					filters[:amenities] = ['doorman']
					filters[:price] 		= AFFORDABLE_APTS_PRICES
				when 'nyc-apartments-with-gyms'
					buildings 					= @buildings.with_amenities(['gym'])
					filters[:amenities] = ['gym']
				# neighborhoods
				when 'studio-apartments-in-brooklyn-for-rent'
					buildings 			= brooklyn_buildings.with_bed(STUDIOS)
					filters[:beds] 	= STUDIOS
				when 'studios-for-rent-in-queens'
					buildings 			= queens_buildings.with_bed(STUDIOS)
					filters[:beds] 	= STUDIOS
				when '2-bedroom-apartments-in-brooklyn-for-rent'
					buildings 			= brooklyn_buildings.two_bed
					filters[:beds] 	= ['2']
				when '2-bedroom-apartments-in-queens-for-rent'
					buildings 			= queens_buildings.two_bed
					filters[:beds] 	= ['2']
				when 'harlem-studio-apartments'
					buildings 		 = buildings_in_neighborhood('harlem').with_bed(STUDIOS)
					filters[:beds] = STUDIOS
				when 'long-island-city-studios'
					buildings 		 = buildings_in_neighborhood('long island city').with_bed(STUDIOS)
					filters[:beds] = STUDIOS
				when 'upper-east-side-studio-apartments'
					buildings 		 = buildings_in_neighborhood('upper east side').with_bed(STUDIOS)
					filters[:beds] = STUDIOS
				when 'upper-west-side-studio-apartments'
					buildings 		 = buildings_in_neighborhood('upper west side').with_bed(STUDIOS)
					filters[:beds] = STUDIOS
				when "hell's-kitchen-studios"
					buildings 		 = buildings_in_neighborhood("hell's kitchen").with_bed(STUDIOS)
					filters[:beds] = STUDIOS
				when 'west-village-studios'
					buildings 		 = buildings_in_neighborhood('west village').with_bed(STUDIOS)
					filters[:beds] = STUDIOS
				when '2-bedroom-apartments-upper-east-side'
					buildings 		 = buildings_in_neighborhood('upper east side').with_bed(['2'])
					filters[:beds] = ['2']
				#Luxury
				when 'penthouses-for-rent-in-nyc'
					buildings = @buildings.penthouse
					filters[:list_min_price] = [Building::PENTHOUSES_MIN_PRICE]
				when 'luxury-apartments-for-rent-in-nyc'
					buildings 					= @buildings.luxury_rentals
					filters[:amenities] = LUXURY_APTS_AMENITIES
				when 'affordable-luxury-apartments-in-nyc'
					buildings 					= @buildings.where(price: AFFORDABLE_LUXURY_APTS_PRICES).luxury_rentals
					filters[:price] 		= AFFORDABLE_LUXURY_APTS_PRICES
					filters[:amenities] = LUXURY_APTS_AMENITIES
				when 'brooklyn-luxury-rentals'
					buildings 					= brooklyn_buildings.luxury_rentals
					filters[:amenities] = LUXURY_APTS_AMENITIES
				when 'luxury-apartments-in-manhattan-for-rent'
					buildings 					= manhattan_buildings.luxury_rentals
					filters[:amenities] = LUXURY_APTS_AMENITIES
				else
					buildings = @buildings
				end
			end

			return buildings, filters
		end

		def manhattan_buildings
			@buildings.where(city: 'New York')
		end

		def brooklyn_buildings
			@buildings.where(city: ['Brooklyn', 'Downtown Brooklyn'])
		end

		def queens_buildings
			@buildings.where(city: QUEENS_CITIES)
		end
	end #end popular search module
end #end search module