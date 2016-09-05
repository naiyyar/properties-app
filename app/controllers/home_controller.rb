class HomeController < ApplicationController
  def index
  end

  def search
    if params['buildings-search-txt'].present?
		  @buildings = Building.near(params['buildings-search-txt'], Building::DISTANCE)
    else
      search = Geocoder.search(params[:term]).first
      if params[:term].present?
    		# second search with building name
      	@buildings = Building.where('building_name @@ :q', q: params[:term])
        if @buildings.present?
          @result_type = 'buildings'
        else
          # second search with city names
          @buildings = Building.where('city @@ :q', q: params[:term])
          if @buildings.present?
            @result_type = 'cities'
          else
            # in last search with building address
            @buildings = Building.neighborhood_search_by_street_address(search, params)
            if @buildings.present?
            	@result_type = 'address'
            else
              @buildings = Building.neighborhood_search_by_zipcode(search, params)
            	@result_type = 'zipcode'
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