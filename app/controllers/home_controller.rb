require 'will_paginate/array'
class HomeController < ApplicationController
  before_action :reset_session, only: [:index, :auto_search]
  before_action :get_neighborhoods, only: [:index]
  before_action :format_search_string, only: :search
  before_action :save_as_favourite, only: [:search]

  def index
    @home_view = true
    @meta_desc = "Search through #{Building.all.count} buildings of no fee apartments in NYC, no fee rentals in NYC, 
                  for rent by owner in NYC and apartment reviews NYC. Rent direct and bypass brokers."
  end

  def load_infobox
    building = Building.find(params[:object_id])
    if params[:current_user_id].present?
      @current_user = User.find(params[:current_user_id])
      fav_color_class = building.favorite_by?(@current_user) ? 'filled-heart' : 'unfilled-heart'
    else
      fav_color_class = 'unfilled-heart'
    end
    
    render json: { html: render_to_string(:partial => "/layouts/shared/custom_infowindow", 
                                          :locals => {  building: building,
                                                        image: Upload.marker_image(building),
                                                        rating_cache: building.rating_cache,
                                                        recomended_per: Vote.recommended_percent(building),
                                                        building_show: params[:building_show],
                                                        current_user: @current_user,
                                                        fav_color_class: fav_color_class,
                                                        broker_percent: BrokerFeePercent.first.percent_amount
                                                      })
                  }
  end

  def auto_search    
    @search_phrase = params[:term]
    @no_match_found = true
    @neighborhoods = Neighborhood.nb_search(@search_phrase) #All neighborhoods
    @buildings = Building.search(@search_phrase)
    @zipcodes = Building.search_by_zipcodes(@search_phrase) #address and name
    @companies = ManagementCompany.text_search_by_management_company(@search_phrase)
    @city = Building.text_search_by_city(@search_phrase).to_a.uniq(&:city)
    
    respond_to do |format|
      #format.html: because if login from search split view after searching something session was saving auto_search path as looking for auto_search template
      format.html { redirect_to root_url }
      format.json
    end
  end

  def search
    search_term = params['search_term']
    if search_term != 'glyphicons-halflings-regular'
      unless params[:latitude].present? and params[:longitude].present?
        if params[:searched_by] != 'address' and params[:searched_by] != 'no-fee-management-companies-nyc'
          @zoom = (@search_string == 'New York' ? 12 : 14)
          unless @search_string == 'New York'
            @brooklyn_neighborhoods =  @search_string #used to add border boundaries of brooklyn and queens
            @neighborhood_coordinates = Gcoordinate.neighbohood_boundary_coordinates(@search_string)

            @boundary_coords = []
            if params[:searched_by] == 'zipcode'
              @buildings = @searched_buildings = Building.where('zipcode = ?', @search_string)
              @boundary_coords << Gcoordinate.where(zipcode: @search_string).map{|rec| { lat: rec.latitude, lng: rec.longitude}}
            elsif params[:searched_by] == 'no-fee-apartments-nyc-neighborhoods'
              @buildings = @searched_buildings = Building.buildings_in_neighborhood(@search_string)
              @boundary_coords << @neighborhood_coordinates unless manhattan_kmls.include?(@search_string)
            else
              if @search_string == 'Manhattan'
                @boundary_coords << Gcoordinate.where(city: 'Manhattan').map{|rec| { lat: rec.latitude, lng: rec.longitude}}
              else
                if @search_string == 'Queens'
                  boroughs = view_context.queens_sub_borough
                elsif @search_string == 'Brooklyn'
                  boroughs = view_context.brooklyn_sub_borough
                elsif @search_string == 'Bronx'
                  boroughs = view_context.bronx_sub_borough
                end
                @buildings = Building.where("city = ? OR neighborhood in (?)", @search_string, boroughs) 
                building = @buildings #Only to show map when no match found after filter
                @zoom = 12
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
        elsif params[:searched_by] == 'no-fee-management-companies-nyc'
          @company = ManagementCompany.where(name: params[:search_term])
          redirect_to management_company_path(@company.first) if @company.present?
        end
      else
        @buildings = Building.redo_search_buildings(params)
        building = @buildings
        @zoom = params[:zoomlevel] || 14
      end
      
      @buildings = Building.filtered_buildings(@buildings, params[:filter]) if params[:filter].present?
      @buildings = Building.sort_buildings(@buildings, params[:sort_by]) if (params[:sort_by].present? and @buildings.present?)
      
      #added unless @buildings.kind_of? Array => getting ratings sorting results in array
      if @buildings.present?
        @buildings = @buildings.includes(:building_average, :featured_building) unless @buildings.kind_of? Array
        #getting all featured building for search term
        building_ids = @buildings.map(&:id)
        featured_buildings = FeaturedBuilding.where(building_id: building_ids).active
        featured_building_ids = featured_buildings.pluck(:building_id)
        
        #Selecting 2 featured building to put on top
        if @buildings.kind_of?(Array)
          #when sorting by rating, getting array of objects
          top_two_featured_buildings = @buildings.select{|b| featured_building_ids.include?(b.id)}
          top_two_featured_buildings = top_two_featured_buildings.shuffle[1..2] if top_two_featured_buildings.length > 2
          @per_page_buildings = @buildings.select{|b| !top_two_featured_buildings.include?(b)}
          #.where.not(id: top_two_featured_buildings.map(&:id))
        else
          top_two_featured_buildings = @buildings.where(id: featured_building_ids)
          top_two_featured_buildings = top_two_featured_buildings.shuffle[1..2] if top_two_featured_buildings.length > 2
          @per_page_buildings = @buildings.where.not(id: top_two_featured_buildings.map(&:id))
        end
        
        @per_page_buildings = @per_page_buildings.paginate(:page => params[:page], :per_page => 20)
        #putting featured building on top
        if top_two_featured_buildings.present?
          @all_building = top_two_featured_buildings + @per_page_buildings
        else
          @all_building = @per_page_buildings
        end
        @hash = Building.buildings_json_hash(top_two_featured_buildings, @buildings)
        @lat = @hash[0]['latitude']
        @lng = @hash[0]['longitude']
        @photos_count = Upload.where(imageable_id: building_ids, imageable_type: 'Building').count
        @reviews_count = Review.where(reviewable_id: building_ids, reviewable_type: 'Building').count
      else
        if @boundary_coords.present? and @boundary_coords.first.length > 1
          @lat = @boundary_coords.first.first[:lat]
          @lng = @boundary_coords.first.first[:lng]
        else
          if @searched_buildings.present?
            @lat = @searched_buildings.first.latitude
            @lng = @searched_buildings.first.longitude
          elsif building.present?
            @lat = building.first.latitude
            @lng = building.first.longitude
          end
        end
      end
      #to calculate save amount
      @broker_percent = BrokerFeePercent.first.percent_amount
      @neighborhood_links = NeighborhoodLink.neighborhood_guide_links(@search_string, view_context.queens_borough)

      @meta_desc = "#{@tab_title_text.try(:titleize)} has #{@buildings.length if @buildings.present?} "+ 
                  "no fee apartment, no fee rental, for rent by owner buildings in NYC you can rent directly from and pay no broker fees. "+ 
                  "View #{@photos_count} photos and #{@reviews_count} reviews."
    end
  end

  def tos
  end

  private
  
  def manhattan_kmls
    ['Midtown', 'Sutton Place', 'Upper East Side', 'Yorkville', 'Bowery']
  end

  def reset_session
    session[:return_to] = nil if session[:return_to].present?
  end

  def get_neighborhoods
    @neighborhoods = Neighborhood.all
  end

  def format_search_string
    if params['search_term'].present?
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
      @tab_title_text = "#{@search_string} #{@borough_city}"
    end
    @half_footer = true
  end

  def save_as_favourite
    if session[:favourite_object_id].present? and current_user.present?
      building = Building.find(session[:favourite_object_id])
      current_user.favorite(building)
      session[:favourite_object_id] = nil
    end
  end
end