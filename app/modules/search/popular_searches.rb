module Search
	module PopularSearches
		QUEENS_CITIES = [ 'Queens','Astoria','Corona','Flushing','Forest Hills',
											'Kew Gardens','Long Island City','Rego Park']
		LUXURY_APTS_AMENITIES = %w(doorman elevator)
		LUXURY_APTS_PRICES = [3,4]
		AFFORDABLE_APTS_PRICES = [1,2]
		STUDIOS = ['0']
		
		def buildings_by_popular_search search_term
			filters = {}
			case search_term
			when 'manhattan-apartments-for-rent'
				buildings 					= manhattan_buildings
				# No use of filters hash here. It's only to fix the SEO tab title
				filters[:amenities] = ['man'] 
			when 'cheap-apartments-in-nyc'
				buildings 			= nyc_buildings.where(price: 1)
				filters[:price] = [1]
			when 'studio-apartments-in-nyc'
				buildings 			= nyc_buildings.studio
				filters[:beds] 	= STUDIOS
			when 'affordable-apartments-for-rent-in-nyc'
				buildings 			= nyc_buildings.where(price: AFFORDABLE_APTS_PRICES)
				filters[:price] = AFFORDABLE_APTS_PRICES
			when 'one-bedroom-apartments-in-nyc'
				buildings 			= nyc_buildings.one_bed
				filters[:beds] 	= ['1']
			when 'cheap-studio-apartments-in-nyc'
				buildings 			= nyc_buildings.studio.where(price: 1)
				filters[:price] = [1]
				filters[:beds] 	= STUDIOS
			when 'luxury-apartments-in-manhattan'
				buildings 					= manhattan_buildings.where(price: LUXURY_APTS_PRICES).doorman.elevator
				filters[:price] 		= LUXURY_APTS_PRICES
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when '2-bedroom-apartments-in-nyc'
				buildings 			= nyc_buildings.two_bed
				filters[:beds] 	= ['2']
			when '3-bedroom-apartments-for-rent-in-nyc'
				buildings 			= nyc_buildings.three_bed
				filters[:beds] 	= ['3']
			when 'manhattan-apartments-for-rent-cheap'
				buildings 			= manhattan_buildings.where(price: AFFORDABLE_APTS_PRICES)
				filters[:price] = AFFORDABLE_APTS_PRICES
			when 'affordable-luxury-apartments-in-nyc'
				buildings 					= nyc_buildings.where(price: [2]).doorman.elevator
				filters[:price] 		= [2]
				filters[:amenities] = LUXURY_APTS_AMENITIES
			# amenities
			when 'doorman-buildings-in-nyc'
				buildings 					= nyc_buildings.doorman
				filters[:amenities] = ['doorman']
			when 'pet-friendly-apartments-in-nyc'
				buildings 					= nyc_buildings.with_pets
				filters[:amenities] = ['pets_allowed_cats', 'pets_allowed_dogs']
			when 'nyc-apartments-with-pool'
				buildings 					= nyc_buildings.swimming_pool
				filters[:amenities] = ['swimming_pool']
			when 'walk-up-apartments-nyc'
				buildings 					= nyc_buildings.walk_up
				filters[:amenities] = ['walk_up']
			when 'affordable-doorman-buildings-nyc'
				buildings 					= nyc_buildings.where(price: AFFORDABLE_APTS_PRICES, doorman: true)
				filters[:amenities] = ['doorman']
				filters[:price] 		= AFFORDABLE_APTS_PRICES
			when 'nyc-apartments-with-gyms'
				buildings 					= nyc_buildings.gym
				filters[:amenities] = ['gym']
			# neighborhoods
			when 'studio-apartments-in-brooklyn'
				buildings 			= brooklyn_buildings.studio
				filters[:beds] 	= STUDIOS
			when 'studios-for-rent-in-queens'
				buildings 			= queens_buildings.studio
				filters[:beds] 	= STUDIOS
			when '2-bedroom-apartments-in-brookly-for-rent'
				buildings 			= brooklyn_buildings.two_bed
				filters[:beds] 	= ['2']
			when '2-bedroom-apartments-in-queens-for-rent'
				buildings 			= queens_buildings.two_bed
				filters[:beds] 	= ['2']
			when 'luxury-apartments-in-upper-east-side'
				buildings 					= buildings_in_neighborhood('Upper East Side').doorman.elevator
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'harlem-studio-apartments'
				buildings 		 = buildings_in_neighborhood('Harlem').studio
				filters[:beds] = STUDIOS
			when 'long-island-city-studios'
				buildings 		 = buildings_in_neighborhood('Long Island City').studio
				filters[:beds] = STUDIOS
			when 'upper-east-side-studio-apartments'
				buildings 		 = buildings_in_neighborhood('Upper East Side').studio
				filters[:beds] = STUDIOS
			when 'upper-west-side-studio-apartments'
				buildings 		 = buildings_in_neighborhood('Upper West Side').studio
				filters[:beds] = STUDIOS
			when "hell's-kitchen-studios"
				buildings 		 = buildings_in_neighborhood("Hell's Kitchen").studio
				filters[:beds] = STUDIOS
			when 'west-village-studios'
				buildings 		 = buildings_in_neighborhood('West Village').studio
				filters[:beds] = STUDIOS
			when '2-bedroom-apartments-upper-east-side'
				buildings 		 = buildings_in_neighborhood('Upper East Side').two_bed
				filters[:beds] = ['2']
			when "hell's-kitchen-luxury-rentals"
				buildings 					= buildings_in_neighborhood("Hell's Kitchen").where(price: LUXURY_APTS_PRICES).doorman.elevator
				filters[:price] 		= LUXURY_APTS_PRICES
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'midtown-studio-apartments-nyc'
				buildings 		 = buildings_in_neighborhood('Midtown').studio
				filters[:beds] = STUDIOS
			when 'midtown-east-luxury-rentals'
				buildings 					= buildings_in_neighborhood('Midtown East').where(price: LUXURY_APTS_PRICES).doorman.elevator
				filters[:price] 		= LUXURY_APTS_PRICES
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'upper-west-side-luxury-rental-buildings'
				buildings 					= buildings_in_neighborhood('Upper West Side').where(price: LUXURY_APTS_PRICES).doorman.elevator
				filters[:price] 		= LUXURY_APTS_PRICES
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'upper-east-side-apartments-for-rent-with-doorman'
				buildings 					= buildings_in_neighborhood('Upper East Side').doorman
				filters[:amenities] = ['doorman']
			else
				buildings = nyc_buildings
			end

			return buildings, filters
		end

		def nyc_buildings
			Building.all
		end

		def manhattan_buildings
			where(city: 'New York')
		end

		def brooklyn_buildings
			where(city: 'Brooklyn')
		end

		def queens_buildings
			where(city: QUEENS_CITIES)
		end
	end #end popular search module
end #end search module