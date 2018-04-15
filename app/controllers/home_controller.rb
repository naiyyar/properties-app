class HomeController < ApplicationController
  
  def index
    session[:return_to] = nil
    @manhattan_neighborhoods = view_context.manhattan_neighborhoods
  end

  def search
    if params['apt-search-txt'].present?
      search_string = params['apt-search-txt'].split(',')[0]
      unless params['term_address'].present?
        unless search_string == 'New York'
          @brooklyn_neighborhoods =  search_string #used to add border boundaries of brooklyn and queens
          @coordinates = Geocoder.coordinates(params['apt-search-txt'])
          @search = Geocoder.search(params['apt-search-txt'])
          if @coordinates.blank? and @search.blank? and params[:term].present?
            @coordinates = Geocoder.coordinates(params[:term])
            @search = Geocoder.search(params[:term])
          end

          search_again_if_empty_results if @search.blank? 
          
          @boundary_coords = []
          
          if @search.present?
            if @search.first.types[0] == 'postal_code'
              search_term = params['apt-search-txt'].split(' - ')
              if(search_term.length > 1)
                zipcode = search_term[0]
                @buildings = Building.where('zipcode = ?',zipcode)
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
          if @coordinates.present?
            @lat = @coordinates[0]
            @lng = @coordinates[1]
          end
        else
          @buildings = Building.buildings_in_city(params, search_string)
          @zoom = 11
        end
      else
        building = Building.where(building_street_address: params[:term_address])
        redirect_to building_path(building.first, 'apt-search-txt' => params['apt-search-txt']) if building.present?
      end
    else
      results = []
      @buildings_by_pneighborhood = Building.search_by_pneighborhoods(params[:term])
      results << @buildings_by_pneighborhood
      @buildings_by_name = Building.search_by_building_name(params[:term])
      results << @buildings_by_name
      @buildings_by_neighborhood = Building.search_by_neighborhood(params[:term]).to_a.uniq(&:neighborhood)
      results << @buildings_by_neighborhood
      @buildings_by_address = Building.search_by_street_address(params[:term]).to_a.uniq(&:building_street_address)
      results << @buildings_by_address
      @buildings_by_zipcode = Building.search_by_zipcodes(params[:term])
      results << @buildings_by_zipcode
      @buildings_by_city = Building.text_search_by_city(params[:term]).to_a.uniq(&:city)
      results << @buildings_by_city
      
      if !results.flatten.present?
        @result_type = 'no_match_found'
      else
        @result_type = 'match_found'
      end
      
    end
    if params['apt-search-txt'].present? and params['apt-search-txt'].split(',')[0] == 'New York'
      @neighborhood_links = NeighborhoodLink.all
    elsif view_context.queens_borough.include?(params[:neighborhoods]) #neighborhoods and city is same
      @neighborhood_links = NeighborhoodLink.where('neighborhood = ?',params[:neighborhoods])
      #@neighborhood_links = NeighborhoodLink.where('parent_neighborhood = ?',params[:neighborhoods]) if @neighborhood_links.blank?
    else
      @neighborhood_links = NeighborhoodLink.where('neighborhood = ? or parent_neighborhood = ?', params[:neighborhoods], params[:neighborhoods])
    end

    @neighborhood_links = @neighborhood_links.order({ date: :desc }, { title: :asc })
    
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
      @buildings = @buildings.paginate(:page => params[:page], :per_page => 20)
	  end

  end

  def tos
  end

  private
  
  def manhattan_kmls
    ['Midtown', 'Sutton Place']
  end

  def search_again_if_empty_results
    if params[:term].blank?
      @coordinates = Geocoder.coordinates(params['apt-search-txt'])
      @search = Geocoder.search(params['apt-search-txt'])
    elsif @coordinates.blank? and params[:term].present?
      @coordinates = Geocoder.coordinates(params[:term])
      @search = Geocoder.search(params[:term])
    end
  end

end