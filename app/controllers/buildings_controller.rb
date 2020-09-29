class BuildingsController < ApplicationController 
  load_and_authorize_resource
  AWS_S3_URL = 'https://s3-us-west-2.amazonaws.com'
  before_action :authenticate_user!,  except: [:index, :show, :contribute, :create, :autocomplete, :apt_search, :favorite, :lazy_load_content]
  before_action :find_building,       only: [:show, :edit, :update, :destroy, :featured_by, :units, :favorite, :unfavorite, :lazy_load_content]
  before_action :clear_cache,         only: [:favorite, :unfavorite]
  before_action :find_buildings,      only: [:contribute, :edit]
  after_action :get_neighborhood,     only: [:create, :update]

  include BuildingsConcern # create, show

  def index
    @filterrific = initialize_filterrific(
      Building,
      params[:filterrific],
      available_filters: [:search_query]
    ) or return
    @buildings = @filterrific.find.paginate(page: params[:page], per_page: 100)
                                  .includes(:building_average, :management_company)
                                  .reorder('created_at desc')
    respond_to do |format|
      format.html
      format.js
    end
  end

  #1. Loading show page content after page load
  # 1.1 Light slider images
  # 1.2 reviews section
  # 1.3 ratings
  def lazy_load_content
    @uploads               = @building.chached_image_uploads
    @uploaded_images_count = @building.uploads_count.to_i
    @reviews               = @building.building_reviews
    respond_to do |format|
      format.js
    end
  end
  
  def sitemap
    redirect_to "#{AWS_S3_URL}/#{ENV['AWS_S3_BUCKET']}/sitemaps/sitemap1.xml"
  end

  def favorite
    if current_user.present?
      current_user.favorite(@building)
      @saved_as_favourite = true
    else
      session[:favourite_object_id] = params[:object_id]
      @saved_as_favourite = false
    end
    respond_to do |format|
      format.js
      format.json{ render json: { success: true } }
    end
  end

  def unfavorite
    current_user.unfavorite(@building)
    render json: { message: 'Success' }
  end

  def units
    @units = @building.units
  end

  def featured_by
    @featured_comps = @building.featured_comps.order(created_at: :desc)
  end

  # disconnecting building from a management company
  def disconnect_building
    Building.where(id: params[:id]).update_all(management_company_id: nil)
    redirect_to :back, notice: 'Building disconnected'
  end

  def contribute
    session[:form_data] = nil if session[:form_data].present?
    @search_type        = 'building'
    if params[:management].present?
      @buildings    = @buildings.where('management_company_id is null')
      @search_type  = 'companies'
    end
    @feature_comp_search_type = params[:featured_on].present? ? 'feature_comp_on' : 'feature_comp_as'
    @buildings                = @buildings.text_search(params[:term])
                                          .reorder('building_street_address ASC')
                                          .limit(10).includes(:units, :management_company)
    @building                 = @buildings.where(id: params[:building_id]).first  if params[:building_id].present?
    @search_bar_hidden        = :hidden
  end

  def import
    ImportReviews.new(params[:file]).import_reviews
    redirect_to :back, notice: 'File imported.'
  end

  def new
    if params['buildings-search-txt'].present?
      @building = Building.find_by_building_street_address(params['buildings-search-txt'])
      if @building.blank?
        address = params['buildings-search-txt'].split(',')[0]
        @building = Building.find_by_building_street_address(address)
      end
    else
      @building = Building.new
    end
  end

  def edit
    @neighborhood_options = @buildings.select('neighborhood').distinct
                                      .where.not(neighborhood: [nil, ''])
                                      .order(neighborhood: :asc).pluck(:neighborhood)
    @neighborhood2        = neighborhoods2
    @neighborhood3        = @buildings.select('neighborhood3').distinct
                                      .where.not(neighborhood3: [nil, ''])
                                      .order(neighborhood3: :asc).pluck(:neighborhood3)
  end

  def update
    if @building.update(building_params)
      session[:after_contribute] = 'amenities' if params[:contribution].present?
      respond_to do |format|
        format.html {
          if params[:subaction].blank?
            redirect_to building_path(@building), notice: 'Successfully Updated'
          else
            redirect_to building_path(@building)
          end
        }
        format.json {render json: @building}
      end
    else
      flash.now[:error] = 'Error Updating'
      render :edit
    end
  end

  def destroy
    @building.destroy
    redirect_to buildings_path, notice: 'Successfully Deleted'
  end

  private

  def find_building
    id = params[:object_id] || params[:id]
    @building = Building.find(id)
  end

  def building_params
    params.require(:building).permit!
  end

  def unit_params
    params[:unit] = params[:building][:units_attributes]['0']
    params.require(:unit).permit(:name, :square_feet, :number_of_bathrooms, :number_of_bedrooms)
  end

  def find_buildings
    @buildings = Building.all
  end

  def neighborhoods2
    [ 
      'East Village', 
      'Flatbush - Ditmas Park', 
      'Greenwich Village', 
      'Harlem', 
      'Lower East Side', 
      'Lower Manhattan', 
      'Midtown', 
      'Midtown South', 
      'Midtown West',
      'SoHo',
      'Upper East Side', 
      'Upper Manhattan', 
      'Upper West Side',
      'Washington Heights'
    ]
  end

  def clear_cache
    @building.update(updated_at: Time.now)
  end

end