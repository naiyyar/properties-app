class HomeController < ApplicationController
  def index
  end

  def search
    if params['apt-search-txt'].present?
      if params[:term].present?
        building = Building.text_search(params[:term])
        redirect_to building_path(building.first) if building.present?
      else
        @buildings = Building.near(params['apt-search-txt'], Building::DISTANCE)
      end
    else
      search = Geocoder.search(params[:term]).first
  
      if params[:term].present?
    		# Search with building name
      	@buildings = Building.text_search(params[:term]).to_a.uniq(&:building_name)
        if @buildings.present?
          @result_type = 'buildings'
        else
          # Search with city names
          @buildings = Building.where('city @@ :q', q: params[:term]).to_a.uniq(&:city)
          if @buildings.present?
            @result_type = 'cities'
          else
            # Search with building address
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