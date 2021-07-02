class HomeController < ApplicationController
  before_action :reset_session,         only: [:index, :auto_search]
  before_action :find_property,         only: [:load_infobox, :get_images]
  before_action :save_as_favourite,     only: [:index, :search]
  # before_action :set_rent_medians,      only: [:search, :load_infobox]
  before_action :set_device_view,       only: [:index, :load_featured_buildings]
  before_action :set_fav_color_class,   only: :load_infobox
  # before_action :set_min_save_amount,   only: :load_infobox
  before_action :set_neighborhood_counts, only: [:lazy_load_content, :load_featured_buildings]
  
  include HomeConcern # search

  def index
    @home_view = true
    @buildings_count = pop_nb_buildings&.size
    @meta_desc = "Rent directly from management companies or landlords in any of these 
                  #{@buildings_count} no fee apartment rental buildings in NYC and 
                  save on broker fees."
    
    @tab_title_text = tab_title_tag
  end

  def load_featured_buildings
    @featured_buildings = FeaturedBuilding.get_random_buildings(pop_nb_buildings)
  end

  def set_split_view_type
    # setting to know on split view in which view user is on list view OR Map View
    session[:view_type] = params[:view_type] if params[:view_type].present?
    render json: { view: session[:view_type] }
  end

  def load_infobox
    building_type_locals = {}
    if @property_type == 'Building'
      filters  = params[:filter_params]
      listings = @property.get_listings(filters)
      building_type_locals = {
        recomended_per: @property.recommended_percent,
        rating_cache:   @property.rating_cache,
        filters:  filters,
        :@listings => listings,
        fav_color_class:  @fav_color_class
      }
    end
    render json: { html: render_to_string(:partial => '/layouts/shared/custom_infowindow', 
                                          :locals => {  property:      @property,
                                                        image:         Upload.marker_image(@property),
                                                        building_show: params[:building_show],
                                                        current_user:  @current_user,
                                                        property_type: @property_type,
                                                      }.merge(building_type_locals))
                }
  end

  def get_images
    @image_uploads = @property.uploads.with_image rescue []
    
    render json: { html: render_slider_partial, 
                   cta_html: render_cta_partial }
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
      # format.html: because if login from search split view after searching something session was saving auto_search path as looking for auto_search template
      format.html { redirect_to root_url }
      format.json
    end
  end

  # Static Content Only
  def lazy_load_content
    respond_to do |format|
      format.js
    end
  end

  def tos
    @meta_desc = 'Terms of service for Transparentcity'
  end

  def advertise_with_us
    @type = params[:type]
    @search_bar_hidden = :hidden
    @meta_desc = advertise_meta_description
  end

  private

  def reset_session
    session[:return_to] = nil
  end

  def find_property
    property_id = params[:object_id] || params[:building_id]
    @property_type = params[:property_type] || 'Building'
    @property = @property_type.constantize.find(property_id)
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
    if @property_type == 'Building'
      @fav_color_class = @property.fav_color_class(params[:current_user_id])
    end
  end

  # def set_min_save_amount
  #   @min_save_amount = @building.min_save_amount(@rent_medians, @broker_percent)
  # end

  def advertise_meta_description
    case @type
    when 'agents'
      'Transparentcity connects Tenant Agents to prospective renters who are looking for personal guidance on navigating the complex rental process.'
    when 'property-managers'
      'Transparentcity advertises exclusively for NYC area landlords and property managers.'
    when 'for-rent-by-owner'
      'Transparentcity connects prospective renters to individual NYC landlord owners.'
    end
  end

  def tab_title_tag
    @tab_title_tag ||= 'Apartments For Rent in NYC'
  end

  def render_slider_partial
    render_to_string(:partial => '/home/lightslider', 
                     :locals => { object:       @property,
                                  images_count: @image_uploads.size,
                                  first_image:  @image_uploads[0],
                                  show_path:    view_context.object_show_path(@property)
                                }
                    )
  end

  def render_cta_partial
    render_to_string(:partial => '/contacts/cta_buttons', 
                     :locals => {  property:       @property,
                                   size_class:     '',
                                   on_click:       false,
                                   info_window: false,
                                   filter_params:  params[:filter_params]
                                }
                  )
  end

  # Setting up buildings counts for uptown, brooklyn, queens, bronx
  def set_neighborhood_counts
    @uptown_count = Neighborhood.nb_buildings_count(pop_neighborhoods, NYCBorough.uptown_sub_borough)
    @brooklyn_count = Building.city_count(pop_nb_buildings, 'Brooklyn', NYCBorough.brooklyn_sub_borough)
    @queens_count = Building.city_count(pop_nb_buildings, 'Queens', NYCBorough.queens_borough)
    @bronx_count = Building.city_count(pop_nb_buildings, 'Bronx', NYCBorough.bronx_sub_borough)
  end
end