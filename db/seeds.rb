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



