class DistanceMatrix
	API_KEY = ENV['GEOCODER_API_KEY']
	DISTANCE = 0.5
	API_URL = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&key=#{API_KEY}"
	
  def initialize
		
	end

	def self.get_data building
		latlng = [building.latitude, building.longitude]
    address = building.street_address
    nearby_stations = SubwayStation.near(latlng, DISTANCE, :order => 'distance').limit(6)
    distance_result = {}
    
    nearby_stations.each_with_index do |station, index|
      st_dest = "#{station.latitude}, #{station.longitude}"
      dis_matrix_api = "#{API_URL}&origins=#{address}&destinations=#{st_dest}"
      response = HTTParty.get(dis_matrix_api)
      distance_result[index] = {}
      distance_result[index][:dest_station] = station.name
      distance_result[index][:results] = response.parsed_response['rows'][0]['elements']
      distance_result[index][:lines] = station.subway_station_lines.select(:line, :color).as_json
      distance_result[index][:distance] = station.distance_to(latlng)
    end
    
    return distance_result
	end

end