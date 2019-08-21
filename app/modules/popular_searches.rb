module PopularSearches
	QUEENS_CITIES = ['Queens','Astoria','Corona','Flushing','Forest Hills','Kew Gardens','Long Island City','Rego Park']
	
	def buildings_by_popular_search params
		case params[:search_term]
		when 'manhattan-apartments-for-rent'
			manhattan_buildings
		when 'cheap-apartments-in-nyc'
			nyc_buildings.where(price: 1)
		when 'studio-apartments-in-nyc'
			nyc_buildings.studio
		when 'affordable-apartments-for-rent-in-nyc'
			nyc_buildings.where(price: [1,2])
		when 'one-bedroom-apartments-in-nyc'
			nyc_buildings.one_bed
		when 'cheap-studio-apartments-in-nyc'
			nyc_buildings.studio.where(price: [1,2])
		when 'luxury-apartments-in-manhattan'
			manhattan_buildings.where(price: [3,4])
		when '2-bedroom-apartments-in-nyc'
			nyc_buildings.two_bed
		when '3-bedroom-apartments-for-rent-in-nyc'
			nyc_buildings.three_bed
		when 'manhattan-apartments-for-rent-cheap'
			manhattan_buildings.where(price: [1,2])
		when 'affordable-luxury-apartments-in-nyc'
			nyc_buildings.where(price: [2,3])
		#amenities
		when 'doorman-buildings-in-nyc'
			nyc_buildings.doorman
		when 'pet-friendly-apartments-in-nyc'
			nyc_buildings.where('pets_allowed_cats is true OR pets_allowed_dogs is true')
		when 'nyc-apartments-with-pool'
			nyc_buildings.swimming_pool
		when 'walk-up-apartments-nyc'
			nyc_buildings.walk_up
		when 'affordable-doorman-buildings-nyc'
			nyc_buildings.where(price: [1,2], doorman: true)
		when 'nyc-apartments-with-gyms'
			nyc_buildings.gym
		#neighborhoods
		when 'studio-apartments-in-brooklyn'
			brooklyn_buildings.studio
		when 'studios-for-rent-in-queens'
			queens_buildings.studio
		when '2-bedroom-apartments-in-brookly-for-rent'
			brooklyn_buildings.two_bed
		when '2-bedroom-apartments-in-queens-for-rent'
			queens_buildings.two_bed
		when 'upper-east-side-apartments-luxury'
			buildings_in_neighborhood('Upper East Side')
		when 'harlem-studio-apartments'
			buildings_in_neighborhood('Harlem').studio
		when 'long-island-city-studios'
			buildings_in_neighborhood('Long Island City').studio
		when 'upper-east-side-studio-apartments'
			buildings_in_neighborhood('Upper East Side').studio
		when 'upper-west-side-studio-apartments'
			buildings_in_neighborhood('Upper West Side').studio
		when "hell's-kitchen-studios"
			buildings_in_neighborhood("Hell's Kitchen").studio
		when 'west-village-studios'
			buildings_in_neighborhood('West Village').studio
		when '2-bedroom-apartments-upper-east-side'
			buildings_in_neighborhood('Upper West Side').two_bed
		when "hell's-kitchen-luxury-rentals"
			buildings_in_neighborhood("Hell's Kitchen").where(price: [3,4])
		when 'midtown-studio-apartments-nyc'
			buildings_in_neighborhood('Midtown').studio
		when 'midtown-east-luxury-rentals'
			buildings_in_neighborhood('Midtown East').where(price: [3,4])
		when 'upper-west-side-luxury-rental-buildings'
			buildings_in_neighborhood('Upper West Side').where(price: [3,4])
		when 'upper-east-side-apartments-for-rent-with-doorman'
			buildings_in_neighborhood('Upper East Side').doorman
		else
			nyc_buildings
		end
	end

	def nyc_buildings
		Building.all
	end

	def manhattan_buildings
		Building.where(city: 'New York')
	end

	def brooklyn_buildings
		Building.where(city: 'Brooklyn')
	end

	def queens_buildings
		Building.where(city: QUEENS_CITIES)
	end

end