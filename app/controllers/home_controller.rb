class HomeController < ApplicationController
  def index
  end

  def search
  	@buildings = Building.search(params['term'])
  	if @buildings.present?
	  	@hash = Gmaps4rails.build_markers(@buildings) do |building, marker|
	      marker.lat building.latitude
	      marker.lng building.longitude
	      building_link = view_context.link_to building.building_name, building_path(building)
	      marker.title "#{building.building_name}, #{building.building_street_address}"

	      marker.infowindow render_to_string(:partial => "/layouts/shared/marker_infowindow", :locals => { building_link: building_link, :building => building })
	  
	    end
	  end
  end

end