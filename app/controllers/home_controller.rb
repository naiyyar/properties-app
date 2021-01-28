require 'will_paginate/array'
class HomeController < ApplicationController
  before_action :reset_session,         only: [:index, :auto_search]
  before_action :find_building,         only: [:load_infobox, :get_images, :set_cta_links]
  before_action :save_as_favourite,     only: [:index, :search]
  #before_action :set_rent_medians,      only: [:search, :load_infobox]
  before_action :set_device_view,       only: [:index, :load_featured_buildings]
  before_action :set_fav_color_class,   only: :load_infobox
  #before_action :set_min_save_amount,   only: :load_infobox
  
  include HomeConcern #search

  def index
    @home_view        = true
    @buildings_count  ||= pop_nb_buildings&.size
    @meta_desc        = "Rent directly from management companies or landlords in any of these 
                         #{@buildings_count} no fee apartment rental buildings in NYC and 
                         save on broker fees."
    
    @tab_title_text   = tab_title_tag
  end

  def load_featured_buildings
    @featured_buildings ||= FeaturedBuilding.get_random_buildings(pop_nb_buildings)
  end

  def set_split_view_type
    #setting to know on split view in which view user is on list view OR Map View
    session[:view_type] = params[:view_type] if params[:view_type].present?
    render json: { view: session[:view_type] }
  end

  def load_infobox
    filters  = params[:filter_params]
    listings = @building.get_listings(filters)
    render json: { html: render_to_string(:partial => '/layouts/shared/custom_infowindow', 
                                          :locals => {  building:         @building,
                                                        image:            Upload.marker_image(@building),
                                                        rating_cache:     @building.rating_cache,
                                                        recomended_per:   @building.recommended_percent,
                                                        building_show:    params[:building_show],
                                                        current_user:     @current_user,
                                                        fav_color_class:  @fav_color_class,
                                                        filters:          filters,
                                                        :@listings =>     listings
                                                      })
                  }
  end

  def get_images
    photos        = Upload.cached_building_photos([params[:building_id]])
    @image_uploads = photos.where(imageable_type: 'Building') rescue []
    render json: { html: render_slider_partial, cta_html: render_cta_partial }
  end

  def auto_search
    @search_phrase  = params[:term]
    @no_match_found = true
    buildings       = pop_nb_buildings # Building.all
    @neighborhoods  = Neighborhood.nb_search(@search_phrase)
    @buildings      = buildings.search_by_building_name_or_address(@search_phrase)
    @zipcodes       = buildings.search_by_zipcodes(@search_phrase)
    @companies      = ManagementCompany.text_search_by_management_company(@search_phrase)
    @city           = buildings.text_search_by_city(@search_phrase).to_a.uniq(&:city)
    
    respond_to do |format|
      #format.html: because if login from search split view after searching something session was saving auto_search path as looking for auto_search template
      format.html { redirect_to root_url }
      format.json
    end
  end

  def tos
  end

  def advertise_with_us
    @type = params[:type]
    @self_service_btn_link =  unless current_user
                                '/users/sign_up'
                              else
                                unless @type == 'agents'
                                  managertools_user_path(current_user, type: 'featured')
                                else
                                  agenttools_user_path(current_user, type: 'featured')
                                end
                              end
    @search_bar_hidden = :hidden
  end

  private

  def reset_session
    session[:return_to] = nil
  end

  def find_building
    building_id = params[:object_id] || params[:building_id]
    @building   = Building.find(building_id)
  end

  def save_as_favourite
    return unless session[:favourite_object_id].present? && current_user.present?
    current_user.add_to_fav(session[:favourite_object_id])
    session[:favourite_object_id] = nil
  end

  def set_device_view
    @mobile_view = browser.device.mobile?
  end

  # def set_rent_medians
  #   @broker_percent = BrokerFeePercent.first.percent_amount
  #   @rent_medians   = RentMedian.all
  # end

  def set_fav_color_class
    @fav_color_class = @building.fav_color_class(params[:current_user_id])
  end

  # def set_min_save_amount
  #   @min_save_amount = @building.min_save_amount(@rent_medians, @broker_percent)
  # end

  def tab_title_tag
    @tab_title_tag ||= 'Apartments For Rent in NYC'
  end

  def render_slider_partial
    render_to_string(:partial => '/home/lightslider', 
                     :locals => { object:       @building,
                                  images_count: @image_uploads.size,
                                  first_image:  @image_uploads[0],
                                  show_path:    building_path(@building)
                                }
                    )
  end

  def render_cta_partial
    render_to_string(:partial => '/contacts/cta_buttons', 
                     :locals => {  building:       @building,
                                   size_class:     '',
                                   on_click:       false,
                                   filter_params:  params[:filter_params]
                                }
                  )
  end
end