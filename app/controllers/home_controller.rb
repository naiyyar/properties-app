class HomeController < ApplicationController
  
  def index
    session[:return_to] = nil
    @manhattan_neighborhoods = view_context.manhattan_neighborhoods
  end

  def auto_search
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

  def search
    search_string = params['search_term'].split(',')[0]
    unless params['term_address'].present?
      unless search_string == 'New York'
        @brooklyn_neighborhoods =  search_string #used to add border boundaries of brooklyn and queens
        @coordinates = Geocoder.coordinates(params['search_term'])
        if @coordinates.present?
          @lat = @coordinates[0]
          @lng = @coordinates[1]
        end

        @boundary_coords = []
        
        if params['term_zipcode'].present?
          @buildings = Building.where('zipcode = ?', params['term_zipcode'])
          @boundary_coords << Gcoordinate.where(zipcode: params['term_zipcode']).map{|rec| { lat: rec.latitude, lng: rec.longitude}}
        elsif params[:neighborhoods].present?
          @buildings = Building.buildings_in_neighborhood(params)
          @zoom = 14
          if !manhattan_kmls.include? @brooklyn_neighborhoods
            @boundary_coords << Gcoordinate.neighbohood_boundary_coordinates(params[:neighborhoods])
          else
            @zoom = 16 if @brooklyn_neighborhoods == 'Sutton Place'
          end
        else
          city = params['search_term'].split(',')[0]
          if city == 'Manhattan'
            @boundary_coords << Gcoordinate.where(city: 'Manhattan').map{|rec| { lat: rec.latitude, lng: rec.longitude}}
            @zoom = 12
          else
            @buildings = Building.buildings_in_city(params, city)
            @zoom = 13
          end
        end
      else
        @buildings = Building.buildings_in_city(params, search_string)
        @zoom = 11
      end
    else
      building = Building.where(building_street_address: params[:term_address])
      redirect_to building_path(building.first) if building.present?
    end
    
    if params['search_term'].present? and params['search_term'].split(',')[0] == 'New York'
      @neighborhood_links = NeighborhoodLink.all
    elsif view_context.queens_borough.include?(params[:neighborhoods])
      @neighborhood_links = NeighborhoodLink.where('neighborhood = ?',params[:neighborhoods])
    else
      @neighborhood_links = NeighborhoodLink.where('neighborhood @@ :q or parent_neighborhood @@ :q', q: params[:neighborhoods])
    end

    @neighborhood_links = @neighborhood_links.order({ date: :desc }, { title: :asc }) if @neighborhood_links.present?
    
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

end