require 'will_paginate/array'
class HomeController < ApplicationController
  
  before_action :reset_session, only: [:index, :auto_search]

  def index
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
    @search_by_mangement = ManagementCompany.text_search_by_management_company(params[:term]).to_a.uniq(&:name)
    results << @search_by_mangement
    
    if !results.flatten.present?
      @result_type = 'no_match_found'
    else
      @result_type = 'match_found'
    end
    
    respond_to do |format|
      #format.html: because if login from search split view after searching something session was saving auto_search path as looking for auto_search template
      format.html { redirect_to root_url }
      format.json
    end
  end

  def search
    search_term = params['search_term']
    if params[:searched_by] != 'address' and params[:searched_by] != 'management_company'
      terms_arr =  search_term.split('-')
      borough_city = terms_arr.last
      search_string = terms_arr.pop #removing last elements-name of city
      search_string = terms_arr.join(' ').titleize #join neighborhoods
      borough_city = (borough_city == 'newyork' ? 'New York' : borough_city.capitalize)
      
      @search_input_value = "#{search_string} - #{borough_city}, NY"
      unless search_string == 'New York'
        @brooklyn_neighborhoods =  search_string #used to add border boundaries of brooklyn and queens
        @coordinates = Geocoder.coordinates("#{search_term}, #{borough_city}, NY")
        if @coordinates.present?
          @lat = @coordinates[0]
          @lng = @coordinates[1]
        end

        @boundary_coords = []
        
        if params['searched_by'] == 'zipcode'
          @buildings = Building.where('zipcode = ?', search_string)
          @boundary_coords << Gcoordinate.where(zipcode: search_string).map{|rec| { lat: rec.latitude, lng: rec.longitude}}
        elsif params['searched_by'] == 'neighborhoods'
          @buildings = Building.buildings_in_neighborhood(search_string)
          @zoom = 14
          if !manhattan_kmls.include? search_string
            @boundary_coords << Gcoordinate.neighbohood_boundary_coordinates(search_string)
          else
            @zoom = 16 if search_string == 'Sutton Place'
          end
        else
          city = search_string
          if city == 'Manhattan'
            @boundary_coords << Gcoordinate.where(city: 'Manhattan').map{|rec| { lat: rec.latitude, lng: rec.longitude}}
            @zoom = 12
          else
            @buildings = Building.buildings_in_city(city)
            @zoom = 13
          end
        end
      else
        @buildings = Building.buildings_in_city(search_string)
        @zoom = 11
      end
    elsif params[:searched_by] == 'address'
      building = Building.where(building_street_address: search_term)
      #searching because some address has extra white space in last so can not match exactly with address search_term
      building = Building.where('building_street_address like ?', "%#{search_term}%") if building.blank?
      redirect_to building_path(building.first) if building.present?
    elsif params[:searched_by] == 'management_company'
      @company = ManagementCompany.where(name: search_term)
      redirect_to management_company_path(@company.first) if @company.present?
    end
    
    if params[:filter].present?
      @rating = params[:filter][:rating]
      @building_types = params[:filter][:type]
      #@beds = params[:filter][:bedrooms]
      @amenities = params[:filter][:amenities]
    end
    
    @buildings = Building.filter_by_amenities(@buildings, @amenities) if @amenities.present?
    @buildings = Building.filter_by_rates(@buildings, @rating) if @rating.present?
    #@buildings = Building.filter_by_beds(@buildings, @beds) #Put on hold for now
    @buildings = Building.filter_by_types(@buildings, @building_types)
    @buildings = Building.sort_buildings(@buildings, params[:sort_by])
    
    if @buildings.present?
      #added unless @buildings.kind_of? Array => getting ratings sorting reasuls in array
      @buildings = @buildings.includes(:uploads, :units, :building_average, :votes) unless @buildings.kind_of? Array
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

    @neighborhood_links = NeighborhoodLink.neighborhood_guide_links(search_string, view_context.queens_borough, params[:neighborhoods])
  end

  def tos
  end

  private
  
  def manhattan_kmls
    ['Midtown', 'Sutton Place']
  end

  def reset_session
    session[:return_to] = nil if session[:return_to].present?
  end

end