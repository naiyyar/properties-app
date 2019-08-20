# file = File.read("#{Rails.root}/public/subway_stations.geojson")
# data_hash = JSON.parse(file)
# data_hash['features'].each do |feature|
# 	st_name = feature['properties']['name']
# 	line = feature['properties']['line']
# 	lat = feature['geometry']['coordinates'][1]
# 	lng = feature['geometry']['coordinates'][0]
# 	station = SubwayStation.create({ name: st_name, latitude: lat, longitude: lng })
# 	lines = line.split('-')
# 	lines.map do |line|
# 		SubwayStationLine.create(subway_station_id: station.id, line: line, color: station.line_color(line)) unless line.include?('Express')
# 	end
# end

##*** TODO LATER ***##
# manhattan = [ 
# 							'Manhattan Apartments For Rent', 'Cheap Apartments In NYC', 'Studio Apartments In NYC',
# 							'Affordable Apartments For Rent In NYC', 'One Bedroom Apartments in NYC', 'Cheap Studio Apartments in NYC',
# 							'Luxury Apartments in Manhattan', '2 Bedroom Apartments in NYC', '3 Bedroom Apartments For Rent in NYC',
# 							'Manhattan Apartments For Rent Cheap', 'Affordable Luxury Apartments In NYC'
# 						]


# amenities = [	'Doorman Buildings In NYC', 'Pet Friendly Apartments In NYC', 'NYC Apartments With Pool', 
# 							'Walk Up Apartments NYC', 'Affordable Doorman Buildings NYC', 'NYC Apartments With Gyms'
# 						]


# neighborhoods = [
# 									'Studio Apartments in Brooklyn', 'Studios For Rent In Queens', '2 Bedroom Apartments in Brookly For Rent', 
# 									'2 Bedroom Apartments in Queens For Rent', 'Upper East Side Apartments Luxury', 'Harlem Studio Apartments',
# 									'Long Island City Studios', 'Upper East Side Studio Apartments', 'Upper West Side Studio Apartments',
# 									"Hell's Kitchen Studios", 'West Village Studios', '2 Bedroom Apartments Upper East Side', "Hell's Kitchen Luxury Rentals",
# 									'Midtown Studio Apartments NYC', 'Midtown East Luxury Rentals', 'Upper West Side Luxury Rental Buildings',
# 									'Upper East Side Apartments For Rent With Doorman'
# 								]

# manhattan.each do |title|
# 	slug = title.downcase.split(' ').join('-')
# 	ps = PopularSearch.create(title: title, category: 'Manhattan', slug: slug)
	
# 	if title == 'Manhattan Apartments For Rent'
# 		Building.where(city: 'New York').each do |Building|
# 			PopularSearchBuilding.create(building_id: building_id, popular_search_id: ps.id)
# 		end
# 	elsif title == 'Cheap Apartments In NYC'
# 	elsif title == 'Studio Apartments In NYC'
# 	elsif title == 'Affordable Apartments For Rent In NYC'
# 	elsif title == 'One Bedroom Apartments in NYC'
# 	elsif title == 'Cheap Studio Apartments in NYC'
# 	elsif title == 'Luxury Apartments in Manhattan'
# 	elsif title == '2 Bedroom Apartments in NYC'
# 	elsif title == '3 Bedroom Apartments For Rent in NYC'
# 	elsif title == 'Manhattan Apartments For Rent Cheap'
# 	elsif title == 'Affordable Luxury Apartments In NYC'
# 	end
# end

# amenities.each do |title|
# 	slug = title.downcase.split(' ').join('-')
# 	PopularSearch.create(title: title, category: 'Amenities', slug: slug)
# end

# neighborhoods.each do |title|
# 	slug = title.downcase.split(' ').join('-')
# 	PopularSearch.create(title: title, category: 'Neighborhoods', slug: slug)
# end



