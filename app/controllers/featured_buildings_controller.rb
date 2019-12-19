class FeaturedBuildingsController < ApplicationController
  load_and_authorize_resource
  before_action :set_featured_building, only: [:show, :edit, :update, :destroy]

  # GET /featured_buildings
  # GET /featured_buildings.json
  def index
    @filterrific = initialize_filterrific(
      FeaturedBuilding,
      params[:filterrific],
      available_filters: [:search_query]
    ) or return
    @featured_buildings = @filterrific.find.paginate(:page => params[:page], :per_page => 100).includes(:building => [:management_company]).order('created_at desc')

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /featured_buildings/1
  # GET /featured_buildings/1.json
  def show
  end

  # GET /featured_buildings/new
  def new
    @featured_building = FeaturedBuilding.new
    @saved_cards       = BillingService.new.get_saved_cards(current_user) rescue nil
  end

  # GET /featured_buildings/1/edit
  def edit
  end

  # POST /featured_buildings
  # POST /featured_buildings.json
  def create
    @featured_building = FeaturedBuilding.new(featured_building_params)

    respond_to do |format|
      if @featured_building.save
        format.html { redirect_to redirect_path, notice: 'Featured building was successfully created.' }
        format.json { render :show, status: :created, location: @featured_building }
      else
        format.html { render :new }
        format.json { render json: @featured_building.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /featured_buildings/1
  # PATCH/PUT /featured_buildings/1.json
  def update
    respond_to do |format|
      if @featured_building.update(featured_building_params)
        format.html { redirect_to featured_buildings_url, notice: 'Featured building was successfully updated.' }
        format.json { render :json => { success: true, data: @featured_building } }
      else
        format.html { render :edit }
        format.json { render json: @featured_building.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /featured_buildings/1
  # DELETE /featured_buildings/1.json
  def destroy
    @featured_building.destroy
    respond_to do |format|
      format.html { redirect_to featured_buildings_url, notice: 'Featured building was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_featured_building
      @featured_building = FeaturedBuilding.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def featured_building_params
      params.require(:featured_building).permit(:building_id, :start_date, :end_date, :active, :user_id, :featured_by)
    end

    def redirect_path
      @featured_building.featured_by_manager? ? new_manager_featured_building_user_path(current_user, type: 'billing', fb_id: @featured_building.id) : featured_buildings_url
    end
end
