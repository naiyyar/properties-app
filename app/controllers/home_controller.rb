require 'will_paginate/array'
class HomeController < ApplicationController
  before_action :reset_session, only: [:index, :auto_search]
  before_action :get_neighborhoods, only: [:index]
  before_action :format_search_string, only: :search

  def index
    @home_view = true
  end

  def load_infobox
    building = Building.find(params[:object_id])

    render json: { html: render_to_string(:partial => "/layouts/shared/custom_infowindow", 
                     :locals => { 
                                  building: building,
                                  image: Upload.marker_image(building),
                                  rating_cache: building.rating_cache,
                                  recomended_per: Vote.recommended_percent(building),
                                  building_show: params[:building_show]
                                }) 
                  }
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
      unless @search_string == 'New York'
        @brooklyn_neighborhoods =  @search_string #used to add border boundaries of brooklyn and queens
        @neighborhood_coordinates = Gcoordinate.neighbohood_boundary_coordinates(@search_string)

        @boundary_coords = []
        if params[:searched_by] == 'zipcode'
          @buildings = Building.where('zipcode = ?', @search_string)
          @boundary_coords << Gcoordinate.where(zipcode: @search_string).map{|rec| { lat: rec.latitude, lng: rec.longitude}}
        elsif params[:searched_by] == 'neighborhoods'
          @buildings = Building.buildings_in_neighborhood(@search_string)
          @boundary_coords << @neighborhood_coordinates unless manhattan_kmls.include?(@search_string)
        else
          if @search_string == 'Manhattan'
            @boundary_coords << Gcoordinate.where(city: 'Manhattan').map{|rec| { lat: rec.latitude, lng: rec.longitude}}
          else
            @buildings = Building.buildings_in_city(@search_string)
          end
        end
      else
        @buildings = Building.buildings_in_city(@search_string)
      end
    elsif params[:searched_by] == 'address'
      building = Building.where(building_street_address: params[:search_term])
      #searching because some address has extra white space in last so can not match exactly with address search_term
      building = Building.where('building_street_address like ?', "%#{params[:search_term]}%") if building.blank?
      redirect_to building_path(building.first) if building.present?
    elsif params[:searched_by] == 'management_company'
      @company = ManagementCompany.where(name: params[:search_term])
      redirect_to management_company_path(@company.first) if @company.present?
    end
    
    @buildings = Building.filtered_buildings(@buildings, params[:filter]) if params[:filter].present?
    @buildings = Building.sort_buildings(@buildings, params[:sort_by]) if (params[:sort_by].present? and @buildings.present?)
  
    #added unless @buildings.kind_of? Array => getting ratings sorting reasuls in array
    if @buildings.present?
      @buildings = @buildings unless @buildings.kind_of? Array
      @per_page_buildings = @buildings.paginate(:page => params[:page], :per_page => 20)
      @hash = Building.buildings_json_hash(@buildings)
    end
    @zoom = (@search_string == 'New York' ? 12 : 14)
    @neighborhood_links = NeighborhoodLink.neighborhood_guide_links(@search_string, view_context.queens_borough)
  end

  def tos
  end

  private
  
  def manhattan_kmls
    ['Midtown', 'Sutton Place', 'Upper East Side']
  end

  def reset_session
    session[:return_to] = nil if session[:return_to].present?
  end

  def get_neighborhoods
    @neighborhoods = Neighborhood.all
  end

  def format_search_string
    terms_arr =  params['search_term'].split('-')
    @borough_city = terms_arr.last
    @search_string = terms_arr.pop #removing last elements-name of city
    @search_string = terms_arr.join(' ').titleize #join neighborhoods
    @search_string = @search_string.gsub('  ', ' -') if @search_string == 'Flatbush   Ditmas Park'
    @search_string = @search_string.gsub(' ', '-') if @search_string == 'Bedford Stuyvesant'
    @search_string = 'New York' if @search_string == 'Newyork'
    
    @borough_city = (@borough_city == 'newyork' ? 'New York' : @borough_city.capitalize)
    @searched_neighborhoods = "#{@search_string}"
    @search_input_value = "#{@searched_neighborhoods} - #{@borough_city}, NY"
    @tab_title_text = "#{@searched_neighborhoods} #{@borough_city}"
  end

end