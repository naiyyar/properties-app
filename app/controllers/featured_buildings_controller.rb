class FeaturedBuildingsController < ApplicationController
  load_and_authorize_resource
  before_action :set_featured_building, only: [:show, :edit, :update, :destroy]

  include Filterrificable

  def index
    @featured_buildings = filterrific_search_results.includes(:user, 
                                                              :building => [:management_company])
    @pagy, @featured_buildings = pagy(@featured_buildings, items: 100)
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
    session[:back_to] = request.fullpath if params[:type] != 'billing'
    @object_id = params[:object_id] || params[:fb_id]
    unless @object_id
      @featured_building = FeaturedBuilding.new
    else
      @featured_by = params[:featured_by] 
      @object_type = 'FeaturedBuilding'
      @object = FeaturedBuilding.find(@object_id)
      @price = Billing::FEATURED_PRICES[@object_type]
      @saved_cards = BillingService.new(current_user).get_saved_cards rescue nil
    end
  end

  # GET /featured_buildings/1/edit
  def edit
    @featured_by = params[:featured_by]
    session[:back_to] = request.fullpath if params[:type] != 'billing'
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
        format.html { redirect_to redirect_path, notice: 'Featured building was successfully updated.' }
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
    respond_to do |format|
      if @featured_building.destroy
        format.html { 
          redirect_to destroy_redirect_url, notice: 'Featured building was successfully deleted.' 
        }
        format.json { head :no_content }
      else
        flash[:error] = @featured_building.errors.messages[:base][0]
        format.html { redirect_to destroy_redirect_url }
      end
    end
  end

  private

    def destroy_redirect_url
      (@featured_building.featured_by_manager? ? :back : featured_buildings_url)
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_featured_building
      @featured_building = FeaturedBuilding.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def featured_building_params
      params.require(:featured_building).permit(:building_id, :start_date, :end_date, :active, :user_id, :featured_by, :renew)
    end

    def redirect_path
      @featured_building.featured_by_manager? ? 
      billing_or_featured_list_path : 
      featured_buildings_url
    end

    def billing_or_featured_list_path
      @featured_building.expired? ? 
      new_manager_featured_building_user_path(current_user, type: 'billing', fb_id: @featured_building.id) :
      managertools_user_path(current_user, type: 'featured')
    end
end
