class HomeController < ApplicationController
  def index
  end

  def search
  	@buildings = Building.text_search(params['term'])
  		
  	@autosearch_buildings = Building.where('building_name @@ :q', q: params[:term])
    if @autosearch_buildings.present?
      @result_type = 'buildings'
    else
      # second search with city names
      @autosearch_buildings = Building.where('city @@ :q', q: params[:term])
      if @autosearch_buildings.present?
        @result_type = 'cities'
      else
        # in last search with building names
        @autosearch_buildings = Building.where('zipcode @@ :q', q: params[:term])
        @result_type = 'zipcode'
      end
    end


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