class HomeController < ApplicationController
  def index
    session[:return_to] = nil
    #@recently_listed_properties = Building.joins(:uploads).order('created_at desc').limit(6)
  end

  def search
    if params['apt-search-txt'].present?
      search_string = params['apt-search-txt'].split(',')[0]
      unless search_string == 'New York'
        @brooklyn_neighborhoods =  search_string#used to add border boundaries of brooklyn and queens
        coordinates = Geocoder.coordinates(params['apt-search-txt'])
        search = Geocoder.search(params['apt-search-txt'])
        @boundary_coords = []
        
        if search.present?
          if search.first.types[0] == 'postal_code'
            search_term = params['apt-search-txt'].split(' - ')
            if(search_term.length > 1)
              zipcode = search_term[0]
              @buildings = Building.where('zipcode = ?',zipcode).paginate(:page => params[:page], :per_page => 20)
              @zoom = 14
            else
              zipcode = params['apt-search-txt']
            end
            @boundary_coords << Gcoordinate.where(zipcode: zipcode).map{|rec| { lat: rec.latitude, lng: rec.longitude}}
            @zoom = 14
          elsif params[:term].present?
            building = Building.where(building_street_address: params[:term])
            redirect_to building_path(building.first, 'apt-search-txt' => params['apt-search-txt']) if building.present?
          elsif params[:neighborhoods].present?
            @buildings = Building.buildings_in_neighborhood(params)
            if !manhattan_kmls.include? @brooklyn_neighborhoods
              geo_coordinates = Gcoordinate.neighbohood_boundary_coordinates(params[:neighborhoods])
              @boundary_coords << geo_coordinates
              @zoom = 14
            else
              @zoom = 16 if @brooklyn_neighborhoods == 'Sutton Place'
            end
          else
            city = params['apt-search-txt'].split(',')[0]
            if city == 'Manhattan'
              @boundary_coords << Gcoordinate.where(city: 'Manhattan').map{|rec| { lat: rec.latitude, lng: rec.longitude}}
              @zoom = 12
            else
              @buildings = Building.buildings_in_city(params, city)
              @zoom = 13
            end
            
          end
        end
        if coordinates.present?
          @lat = coordinates[0]
          @lng = coordinates[1]
        end
      else
        @buildings = Building.buildings_in_city(params, search_string)
        @zoom = 10
      end
    else
      if params[:term].present?
    		# Search with zipcode
        @buildings = Building.text_search_by_zipcode(params[:term])
        if @buildings.present?
          @result_type = 'zipcode'
        else
          #results = PgSearch.multisearch(params[:term])
          #@buildings = Building.where(id: results.map(&:searchable_id)).to_a.uniq(&:neighborhood)
          @buildings = Building.search_by_pneighborhoods(params[:term])
          if @buildings.present?
            @result_type = 'pneighborhood'
          else
            @buildings = Building.search_by_neighborhoods(params[:term])
            #@buildings = Building.where('neighborhood @@ :q or neighborhoods_parent @@ :q', q: "%#{params[:term]}%").to_a.uniq(&:neighborhood)
            if @buildings.present?
          	  @result_type = 'neighborhood'
            else
              @buildings = Building.search_by_building_name(params[:term]) #.reorder(:building_name)
          	  if @buildings.present?
                @result_type = 'building_name'
              else
                # Search with address
                #@buildings = Building.search_by_street_address(params[:term])
                @buildings = Building.where('building_street_address ILIKE ?', "%#{params[:term]}%").to_a.sort_by{ |b| b.building_street_address }
                if @buildings.present?
                  @result_type = 'address'
                else
                  @buildings = Building.where('city ILIKE ?', "%#{params[:term]}%").to_a.uniq(&:city)
                  if @buildings.present?
                    @result_type = 'cities'
                  else
                    @result_type = 'no_match_found'
                  end
                end
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
	      marker.title "#{building.id}, #{building.building_name}, #{building.street_address}, #{building.zipcode}"
        
	      marker.infowindow render_to_string(:partial => "/layouts/shared/marker_infowindow", 
                                           :locals => { 
                                                        building: building,
                                                        image: Upload.marker_image(building)
                                                      }
                                          )
	    end
	  end
  end

  def tos
  end

  private
  def manhattan_kmls
    ['Midtown', 'Sutton Place']
  end

end