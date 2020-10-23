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

queens_nb = [	'Astoria',
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

nbs 			= Neighborhood.where(boroughs: 'QUEENS')
buildings = Building.all
queens_nb.each do |nb|
	hood 		= nbs.where(name: nb.downcase)
	count 	= buildings.buildings_in_neighborhood(nb.downcase).count
	puts "#{nb} buildings count: #{count}"
	if hood.blank?
		Neighborhood.create({ name: 					nb, 
												boroughs: 			'QUEENS', 
												buildings_count: count})
	else
		nb.update(buildings_count: count)
	end
end



