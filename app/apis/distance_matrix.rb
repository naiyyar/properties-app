class DistanceMatrix
	API_KEY = ENV['GEOCODER_API_KEY']
	DISTANCE = 0.5
	API_URL = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&key=#{API_KEY}"

	def self.get_data building
		latlng = [building.latitude, building.longitude]
    address = building.street_address
    nearby_stations = SubwayStation.near(latlng, DISTANCE, :order => 'distance').limit(6)
    distance_result = {}
    
    nearby_stations.each_with_index do |station, index|
      st_dest = "#{station.latitude}, #{station.longitude}"
      distance_result[index] = {}
      if station.st_duration.blank?
        dis_matrix_api = "#{API_URL}&origins=#{address}&destinations=#{st_dest}"
        begin
          dis_matrix_api = URI.parse(dis_matrix_api)
        rescue URI::InvalidURIError
          dis_matrix_api = URI.parse(URI.escape(dis_matrix_api))
        end
        response = HTTParty.get(dis_matrix_api)
        distance_result[index][:results] = response.parsed_response['rows'][0]['elements']
        station.update(st_distance: station.distance_to(latlng), st_duration: distance_result[index][:results][0]['duration']['text'])
      end
      
      distance_result[index][:dest_station] = station.name
      distance_result[index][:lines] = station.subway_station_lines.select(:line, :color).as_json
      distance_result[index][:distance] = station.st_distance
      distance_result[index][:duration] = station.st_duration
    end
    
    return distance_result
	end

end