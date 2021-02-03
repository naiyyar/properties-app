# To find nearby station and their distance & duration from the building
class DistanceMatrixService
	API_KEY  = ENV['GEOCODER_API_KEY']
	DISTANCE = 0.5
	API_URL  = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&key=#{API_KEY}"
  
  def initialize building
    @latlng          = [building.latitude, building.longitude]
    @address         = building.street_address
    @distance_result = {}
  end

  def get_data
    nearby_stations.each_with_index do |station, index|
      st_dest = "#{station.latitude}, #{station.longitude}"
      @distance_result[index] = {}
      if station.st_duration.blank?
        @distance_result[index][:results] = parsed_response(st_dest)
        station.update(st_distance: station.distance_to(@latlng), 
                       st_duration: @distance_result[index][:results][0]['duration']['text'])
      end
      @distance_result[index][:dest_station] = station.name
      @distance_result[index][:lines]        = station.subway_station_lines.select(:line, :color).as_json
      @distance_result[index][:distance]     = station.st_distance
      @distance_result[index][:duration]     = station.st_duration
    end
    
    return @distance_result
	end

  private 
  def nearby_stations
    SubwayStation.includes(:subway_station_lines)
                  .near(@latlng, DISTANCE, :order => 'distance')
                  .limit(6)
  end

  def parsed_response st_dest
    http_response(st_dest).parsed_response['rows'][0]['elements']
  end

  def http_response st_dest
    HTTParty.get(parsed_api_url(st_dest))
  end

  def parsed_api_url destination_station
    dis_matrix_api = "#{API_URL}&origins=#{@address}&destinations=#{destination_station}"
    begin
      dis_matrix_api = URI.parse(dis_matrix_api)
    rescue URI::InvalidURIError
      dis_matrix_api = URI.parse(URI.escape(dis_matrix_api))
    end
    dis_matrix_api
  end

end