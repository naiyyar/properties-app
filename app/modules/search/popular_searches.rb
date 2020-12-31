module Search
	module PopularSearches
		QUEENS_CITIES 				  = [ 'Queens','Astoria','Corona','Flushing','Forest Hills',
															  'Kew Gardens','Long Island City','Rego Park']
		LUXURY_APTS_AMENITIES   = %w(doorman elevator)
		LUXURY_APTS_PRICES 			= [3,4]
		AFFORDABLE_APTS_PRICES  = [1,2]
		AFFORDABLE_LUXURY_APTS_PRICES  = [2]
		STUDIOS 								= ['0']
		
		def buildings_by_popular_search search_term, buildings
			filters = {}
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
				buildings 			= @buildings.co_living
				filters[:beds] 	= ['5']
			when 'studio-apartments-in-nyc-for-rent'
				buildings 			= @buildings.studio
				filters[:beds] 	= STUDIOS
			when 'affordable-apartments-for-rent-in-nyc'
				buildings 			= @buildings.where(price: AFFORDABLE_APTS_PRICES)
				filters[:price] = AFFORDABLE_APTS_PRICES
			when 'cheap-apartments-in-nyc-for-rent'
				buildings 			= @buildings.where(price: 1)
				filters[:price] = [1]
			when '2-bedroom-apartments-in-nyc'
				buildings 			= @buildings.two_bed
				filters[:beds] 	= ['2']
			when '3-bedroom-apartments-for-rent-in-nyc'
				buildings 			= @buildings.three_bed
				filters[:beds] 	= ['3']
			when 'one-bedroom-apartments-in-nyc-for-rent'
				buildings 			= @buildings.one_bed
				filters[:beds] 	= ['1']
			when 'cheap-studio-apartments-in-nyc-for-rent'
				buildings 			= @buildings.studio.where(price: 1)
				filters[:price] = [1]
				filters[:beds] 	= STUDIOS
			# amenities
			when 'pet-friendly-apartments-in-nyc'
				buildings 					= @buildings.with_pets
				filters[:amenities] = ['pets_allowed_cats', 'pets_allowed_dogs']
			when 'nyc-apartments-with-pool'
				buildings 					= @buildings.swimming_pool
				filters[:amenities] = ['swimming_pool']
			when 'walk-up-apartments-nyc'
				buildings 					= @buildings.walk_up
				filters[:amenities] = ['walk_up']
			when 'affordable-doorman-buildings-nyc'
				buildings 					= @buildings.where(price: AFFORDABLE_APTS_PRICES, doorman: true)
				filters[:amenities] = ['doorman']
				filters[:price] 		= AFFORDABLE_APTS_PRICES
			when 'nyc-apartments-with-gyms'
				buildings 					= @buildings.gym
				filters[:amenities] = ['gym']
			# neighborhoods
			when 'studio-apartments-in-brooklyn-for-rent'
				buildings 			= brooklyn_buildings.studio
				filters[:beds] 	= STUDIOS
			when 'studios-for-rent-in-queens'
				buildings 			= queens_buildings.studio
				filters[:beds] 	= STUDIOS
			when '2-bedroom-apartments-in-brooklyn-for-rent'
				buildings 			= brooklyn_buildings.two_bed
				filters[:beds] 	= ['2']
			when '2-bedroom-apartments-in-queens-for-rent'
				buildings 			= queens_buildings.two_bed
				filters[:beds] 	= ['2']
			when 'harlem-studio-apartments'
				buildings 		 = buildings_in_neighborhood('harlem').studio
				filters[:beds] = STUDIOS
			when 'long-island-city-studios'
				buildings 		 = buildings_in_neighborhood('long island city').studio
				filters[:beds] = STUDIOS
			when 'upper-east-side-studio-apartments'
				buildings 		 = buildings_in_neighborhood('upper east side').studio
				filters[:beds] = STUDIOS
			when 'upper-west-side-studio-apartments'
				buildings 		 = buildings_in_neighborhood('upper west side').studio
				filters[:beds] = STUDIOS
			when "hell's-kitchen-studios"
				buildings 		 = buildings_in_neighborhood("hell's kitchen").studio
				filters[:beds] = STUDIOS
			when 'west-village-studios'
				buildings 		 = buildings_in_neighborhood('west village').studio
				filters[:beds] = STUDIOS
			when '2-bedroom-apartments-upper-east-side'
				buildings 		 = buildings_in_neighborhood('upper east side').two_bed
				filters[:beds] = ['2']
			#Luxury
			when 'penthouses-for-rent-in-nyc'
				# Listing Price >= $8,000
				#building_ids 				     = Listing.where('rent > ?', PENTHOUSES_MIN_PRICE).pluck(:building_id)
				buildings = @buildings.penthouse
				# buildings 					     = @buildings.penthouses_luxury_rentals(building_ids.uniq)
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
			#Luxury Neighborhoods
			when 'battery-park-city-luxury-rentals'
				buildings 					= buildings_in_neighborhood('battery park city').luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'chelsea-luxury-rentals'
				buildings 					= buildings_in_neighborhood('chelsea').luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'downtown-brooklyn-luxury-rentals'
				buildings 					= buildings_in_neighborhood('downtown brooklyn').luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'east-harlem-luxury-rentals'
				buildings 					= buildings_in_neighborhood('east harlem').luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'east-village-luxury-rentals'
				buildings 					= buildings_in_neighborhood('east village').luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'financial-district-luxury-rentals'
				buildings 					= buildings_in_neighborhood('financial district').luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'gramercy-luxury-rentals'
				buildings 					= buildings_in_neighborhood('gramercy park').luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'harlem-luxury-rentals'
				buildings 					= buildings_in_neighborhood('harlem').luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when "hell's-kitchen-luxury-rentals"
				buildings 					= buildings_in_neighborhood("hell's kitchen").luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'kips-bay-luxury-rentals'
				buildings 					= buildings_in_neighborhood('kips bay').luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'long-island-city-luxury-rentals'
				buildings 					= buildings_in_neighborhood('long island city').luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'midtown-east-luxury-rentals'
				buildings 					= buildings_in_neighborhood('midtown east').luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'midtown-west-luxury-rentals'
				buildings 					= buildings_in_neighborhood('midtown west').luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'murray-hill-luxury-rentals'
				buildings 					= buildings_in_neighborhood('murray hill').luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'roosevelt-island-luxury-rentals'
				buildings 					= buildings_in_neighborhood('roosevelt island').luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'tribeca-luxury-rentals'
				buildings 					= buildings_in_neighborhood('tribeca').luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'upper-east-side-luxury-rentals'
				buildings 					= buildings_in_neighborhood('upper east side').luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'upper-west-side-luxury-rentals'
				buildings 					= buildings_in_neighborhood('upper west side').luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'west-village-luxury-rentals'
				buildings 					= buildings_in_neighborhood('west village').luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			when 'williamsburg-luxury-rentals'
				buildings 					= buildings_in_neighborhood('williamsburg').luxury_rentals
				filters[:amenities] = LUXURY_APTS_AMENITIES
			else
				buildings = @buildings
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