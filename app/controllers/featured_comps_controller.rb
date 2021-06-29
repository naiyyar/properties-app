class FeaturedCompsController < ApplicationController
  load_and_authorize_resource
  before_action :set_featured_comp, only: [:show, :edit, :update, :destroy, :disconnect_building]
  before_action :set_comp_buildings, only: [:show, :edit]
  
  include Searchable

  def index
    @featured_comps = filterrific_search_results.includes(:building => [:management_company])
    @pagy, @featured_comps = pagy(@featured_comps, items: 100)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
    @buildings = @comp_buildings.includes(:management_company, :building_average)
  end

  # disconnecting building from a management company
  def disconnect_building
    buildings = @featured_comp.featured_comp_buildings.where(building_id: params[:building_id])
    buildings.first.delete if buildings.present?
    flash[:notice] = 'Building disconnected'
    redirect_to request.referer
  end

  def new
    @featured_comp = FeaturedComp.new
  end

  def edit
    @pagy, @featured_on_buildings = pagy(@comp_buildings)
  end

  def create
    @featured_comp = FeaturedComp.new(featured_comp_params)

    respond_to do |format|
      if @featured_comp.save
        @featured_comp.add_featured_building(params[:comparable_building_ids]) if params[:comparable_building_ids].present?
        format.html { redirect_to featured_comps_path, notice: 'Featured comp was successfully created.' }
        format.json { render :show, status: :created, location: @featured_comp }
      else
        format.html { render :new }
        format.json { render json: @featured_comp.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @featured_comp.update(featured_comp_params)
        @featured_comp.add_featured_building(params[:comparable_building_ids]) if params[:comparable_building_ids].present?
        format.html { redirect_to featured_comps_path, notice: 'Featured comp was successfully updated.' }
        format.json { render :json => { success: true, data: @featured_comp } }
      else
        format.html { render :edit }
        format.json { render json: @featured_comp.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @featured_comp.destroy
    respond_to do |format|
      format.html { redirect_to featured_comps_url, notice: 'Featured comp was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_featured_comp
      @featured_comp = FeaturedComp.find(params[:id])
    end

    def set_comp_buildings
      @comp_buildings = @featured_comp.buildings
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def featured_comp_params
      params.require(:featured_comp).permit(:building_id, :start_date, :end_date, :active)
    end
end
