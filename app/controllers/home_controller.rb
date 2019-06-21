require 'will_paginate/array'
class HomeController < ApplicationController
  before_action :reset_session, only: [:index, :auto_search]
  before_action :format_search_string, only: :search
  before_action :save_as_favourite, only: [:search]

  def index
    @home_view = true
    @neighborhoods = Neighborhood.all
    @buildings_count = Building.all.count
    @meta_desc = "Search through #{@buildings_count} buildings of no fee apartments in NYC, no fee rentals in NYC, 
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
                                                        recomended_per: building.recommended_percent,
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
          #searched: Method in building search module
          results = Building.searched(params[:searched_by], @search_string, @sub_borough)
          building = @buildings = @searched_buildings = results['buildings']
          @boundary_coords = results['boundary_coords'] if results['boundary_coords'].present?
          @zoom = results['zoom'] if results['zoom'].present?
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
        building_ids = @buildings.pluck(:id)
        final_results = Building.with_featured_building(@buildings, building_ids, params[:page])
        @per_page_buildings = final_results[:per_page_buildings]
        @all_buildings = final_results[:all_buildings]
        @hash = final_results[:map_hash]
        @lat = @hash[0]['latitude']
        @lng = @hash[0]['longitude']
        #in meta_desc
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

  def reset_session
    session[:return_to] = nil if session[:return_to].present?
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

      if !searched_params.include?(params[:searched_by])
        @sub_borough = {}
        @sub_borough['Queens'] = view_context.queens_sub_borough
        @sub_borough['Brooklyn'] = view_context.brooklyn_sub_borough
        @sub_borough['Bronx'] = view_context.bronx_sub_borough
      end
    end
    @half_footer = true
  end

  def searched_params
    ['address', 'no-fee-management-companies-nyc', 'zipcodes']
  end

  def save_as_favourite
    if session[:favourite_object_id].present? and current_user.present?
      building = Building.find(session[:favourite_object_id])
      current_user.favorite(building)
      session[:favourite_object_id] = nil
    end
  end
end