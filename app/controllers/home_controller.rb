class HomeController < ApplicationController
  before_action :reset_session,         only: [:index, :auto_search]
  before_action :find_property,         only: [:load_infobox, :get_images]
  before_action :set_neighborhood_counts, only: [:lazy_load_content, :load_featured_buildings]
  
  include SearchConcern # search

  def index
    @home_view = true
    @buildings_count = Building.all.size
  end

  def load_featured_buildings
    @featured_buildings = FeaturedBuilding.get_random_buildings(pop_nb_buildings)
  end

  def get_images
    @image_uploads = @property.uploads.with_image rescue []
    
    render json: { html: render_slider_partial, 
                   cta_html: render_cta_partial }
  end

  def auto_search
    @search_phrase  = params[:term]
    buildings       = Building.all
    @neighborhoods  = Neighborhood.nb_search(@search_phrase)
    @buildings      = buildings.search_by_building_name_or_address(@search_phrase)
    @zipcodes       = buildings.search_by_zipcodes(@search_phrase)
    @companies      = ManagementCompany.text_search_by_management_company(@search_phrase)
    @city           = buildings.text_search_by_city(@search_phrase).to_a.uniq(&:city)
    
    respond_to do |format|
      format.json
    end
  end

  private

  def find_property
    property_id = params[:object_id] || params[:building_id]
    @property_type = params[:property_type] || 'Building'
    @property = @property_type.constantize.find(property_id)
  end

  def render_slider_partial
    render_to_string(:partial => '/home/lightslider', 
                     :locals => { object: @property,
                                  images_count: @image_uploads.size,
                                  first_image: @image_uploads[0],
                                  show_path: view_context.object_show_path(@property)
                                }
                    )
  end

  def render_cta_partial
    render_to_string(:partial => '/contacts/cta_buttons', 
                     :locals => {  property: @property,
                                   size_class: '',
                                   on_click: false,
                                   info_window: false,
                                   filter_params: params[:filter_params]
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