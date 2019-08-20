module PopularSearches

	def buildings_by_popular_search params
		st = params[:search_term]
		case st
		when 'manhattan-apartments-for-rent'
			Building.where(city: 'New York')
		when 'cheap-apartments-in-nyc'
			Building.where(price: 1)
		when 'studio-apartments-in-nyc'
			Building.studio
		when 'affordable-apartments-for-rent-in-nyc'
			Building.where(price: [1,2])
		when 'one-bedroom-apartments-in-nyc'
			Building.one_bed
		when 'cheap-studio-apartments-in-nyc'
			Building.studio.where(price: [1,2])
		when 'luxury-apartments-in-manhattan'
			Building.where(city: 'New York', price: [3,4])
		when '2-bedroom-apartments-in-nyc'
			Building.two_bed
		when '3-bedroom-apartments-for-rent-in-nyc'
			Building.three_bed
		when 'manhattan-apartments-for-rent-cheap'
			Building.where(city: 'New York', price: [1,2])
		when 'affordable-luxury-apartments-in-nyc'
			Building.where(price: [2,3])
		else
			Building.all
		end
	end

end