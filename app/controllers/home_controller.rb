class HomeController < ApplicationController
  def index
  end

  def search
    if params['apt-search-txt'].present?
      if params[:term].present?
        building = Building.where(building_street_address: params[:term])
        redirect_to building_path(building.first) if building.present?
      else
        search = Geocoder.search(params['apt-search-txt'])
        coordinates = Geocoder.coordinates(params['apt-search-txt'])
        @buildings = Building.near(params['apt-search-txt'], Building::DISTANCE)
        if search.present?
           @boundary_coords = []
          if search.first.types[0] == 'postal_code'
            search_term = params['apt-search-txt'].split(' - ')
            if coordinates.present?
              @lat = coordinates[0]
              @lng = coordinates[1]
            end
            if(search_term.length > 1)
              zipcode = search_term[0]
              @buildings = Building.where('zipcode = ?',zipcode).to_a.uniq(&:building_street_address)
            else
              zipcode = params['apt-search-txt']
            end
            @boundary_coords << Gcoordinate.where(zipcode: zipcode).map{|rec| { lat: rec.latitude, lng: rec.longitude}}
            @zoom = 14
          elsif search.first.types[0] == 'neighborhood'
            if coordinates.present?
              @lat = coordinates[0]
              @lng = coordinates[1]
            end
            neighborhoods = params['apt-search-txt'].split(',')[0]
            @buildings = Building.where(neighborhood: neighborhoods).to_a.uniq(&:building_street_address)
            @boundary_coords << Gcoordinate.where(neighborhood: neighborhoods).map{|rec| { lat: rec.latitude, lng: rec.longitude}}
            @zoom = 14
          else
            @boundary_coords << Gcoordinate.where(city: 'Manhattan').map{|rec| { lat: rec.latitude, lng: rec.longitude}}
            @zoom = 12
          end
        end
      end
    else
     # search = Geocoder.search(params[:term]).first
      if params[:term].present?
    		# Search with city name
      	@buildings = Building.text_search_by_city(params[:term]).to_a.uniq(&:city)
        if @buildings.present?
          @result_type = 'cities'
        else
          # Search with zipcode
          @buildings = Building.text_search_by_zipcode(params[:term])
          if @buildings.present?
            @result_type = 'zipcode'
          else
            # Search with building address
            @buildings = Building.search_by_street_address(params[:term])
            if @buildings.present?
            	@result_type = 'address'
            else
              # Search with Neighborhood
              @buildings = Building.text_search_by_neighborhood(params[:term])
            	if @buildings.present?
                @result_type = 'neighborhood'
              else
                # Search with building names
                @buildings = Building.text_search_by_building_name(params[:term])
                @result_type = 'buildings'
              end
          	end
          end
        end
      end
    end
    if @buildings.present?
	  	@hash = Gmaps4rails.build_markers(@buildings) do |building, marker|
        marker.lat building.latitude
	      marker.lng building.longitude
	      building_link = view_context.link_to building.building_name, building_path(building)
	      marker.title "#{building.id}, #{building.building_name}, #{building.building_street_address}, #{building.zipcode}"

	      marker.infowindow render_to_string(:partial => "/layouts/shared/marker_infowindow", :locals => { building_link: building_link, :building => building })
	    end
	  end
  end

end