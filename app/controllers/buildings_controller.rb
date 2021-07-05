class BuildingsController < ApplicationController 
  load_and_authorize_resource
  
  before_action :find_building,    only: [:show, :edit, :update, :destroy, :featured_by, :units, :favorite, :unfavorite]
  before_action :find_buildings,   only: :edit

  include Filterrificable

  def index
    @buildings = filterrific_search_results.includes(:management_company, :uploads, :featured_comps)
    @buildings_count = @buildings.count
    @pagy, @buildings = pagy(@buildings, items: 100)
    
    respond_to do |format|
      format.html
      format.js
    end
  end

  # disconnecting building from a management company
  def disconnect_building
    Building.where(id: params[:id]).update_all(management_company_id: nil)
    flash[:notice] = 'Building disconnected'
    respond_to do |format|
      format.js
    end
  end

  def import
    ImportReviews.new(params[:file]).import_reviews
    flash[:notice] = 'File imported.'
    redirect_back(fallback_location: reviews_path)
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

  def show
  end

  def edit
    @neighborhood_options = Building.neighborhood1
    @neighborhood2 = NYCBorough.nyc_parent_neighborhoods
    @neighborhood3 = @buildings.select('neighborhood3').distinct
                               .where.not(neighborhood3: [nil, ''])
                               .order(neighborhood3: :asc).pluck(:neighborhood3)
  end

  def create
    @building.user = current_user
    @building = Building.new(building_params)
    if @building.save
      respond_to do |format|
        format.html {
          redirect_to building_path(@building), notice: 'Successfully Updated'
        }
        format.json {render json: @building}
      end
    else
      flash[:error] = "Error Updating: #{@building.errors.messages}"
      redirect_back(fallback_location: edit_building_path(@building))
    end
  end

  def update
    @building.user = current_user
    if @building.update(building_params)
      respond_to do |format|
        format.html {
          redirect_to building_path(@building), notice: 'Successfully Updated'
        }
        format.json {render json: @building}
      end
    else
      flash[:error] = "Error Updating: #{@building.errors.messages}"
      redirect_back(fallback_location: edit_building_path(@building))
    end
  end

  def destroy
    @building.destroy
    redirect_to buildings_path, notice: 'Successfully Deleted'
  end

  private

  def find_building
    @building = Building.find(params[:id])
  end

  def building_params
    params.require(:building).permit!
  end

  def find_buildings
    @buildings = Building.all
  end

end