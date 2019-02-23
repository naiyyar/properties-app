class ManagementCompaniesController < ApplicationController
  load_and_authorize_resource
  before_action :set_management_company, only: [:show, :edit, :update, :destroy, :managed_buildings]
  before_action :save_as_favourite, only: [:show]
  # GET /management_companies_url
  # GET /management_companies.json
  def index
    @management_companies = ManagementCompany.all
  end

  def managed_buildings
    @buildings = @management_company.buildings #.reorder('neighborhood ASC, building_name ASC')
  end

  def load_more_reviews
    buildings = @management_company.buildings
    @reviews = Review.where(reviewable_id: buildings.pluck(:id), reviewable_type: 'Building').includes(:user, :uploads)
    @reviews = @reviews.where('id < ?', params[:object_id]).limit(10) if params[:object_id].present?
    
    respond_to do |format|
      format.js
    end
  end

  # GET /management_companies/1
  # GET /management_companies/1.json
  def show
    @show_map_btn = true
    buildings = @management_company.buildings.reorder(neighborhood: :asc, building_name: :asc, building_street_address: :asc)
    @manage_buildings = buildings.paginate(:page => params[:page], :per_page => 20) if !params[:object_id].present?
    @reviews = Review.where(reviewable_id: buildings.pluck(:id), reviewable_type: 'Building').includes(:user, :uploads, :reviewable).limit(10)
    @building_photos = Upload.where(imageable_id: @manage_buildings.pluck(:id), imageable_type: 'Building')
    
    if buildings.present?
      #finding average rating for all managed buildings 
      @stars = @management_company.get_average_stars
      
      #For Gmap
      @lat = buildings.first.latitude
      @lng = buildings.first.longitude
      @zoom = buildings.length > 60 ? 13 : 11
      @hash = Building.buildings_json_hash(buildings.includes(:uploads, :building_average, :votes))
    end

    @meta_desc = "#{@management_company.name} manages #{@manage_buildings.count} no fee apartment, no fee rental, 
                  for rent by owner buildings in NYC you can rent directly from and pay no broker fees. 
                  Click to view #{@building_photos.count} photos and #{@management_company.aggregate_reviews} reviews."
   end

  # GET /management_companies/new
  def new
    @management_company = ManagementCompany.new
  end

  # GET /management_companies/1/edit
  def edit
    @buildings = @manage_buildings = @management_company.buildings.paginate(:page => params[:page], :per_page => 20)
  end

  # POST /management_companies
  # POST /management_companies.json
  def create
    @management_company = ManagementCompany.new(management_company_params)

    respond_to do |format|
      if @management_company.save
        @management_company.add_building(params[:managed_building_ids]) if params[:managed_building_ids].present?
        format.html { redirect_to management_companies_url, notice: 'Management company was successfully created.' }
        format.json { render :show, status: :created, location: @management_company }
      else
        format.html { render :new }
        format.json { render json: @management_company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /management_companies/1
  # PATCH/PUT /management_companies/1.json
  def update
    @management_company.add_building(params[:managed_building_ids]) if params[:managed_building_ids].present?
    respond_to do |format|
      if @management_company.update(management_company_params)
        format.html { redirect_to management_companies_url, notice: 'Management company was successfully updated.' }
        format.json { render :show, status: :ok, location: @management_company }
      else
        format.html { render :edit }
        format.json { render json: @management_company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /management_companies/1
  # DELETE /management_companies/1.json
  def destroy
    @management_company.destroy
    respond_to do |format|
      format.html { redirect_to management_companies_url, notice: 'Management company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_management_company
      @management_company = ManagementCompany.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def management_company_params
      params.require(:management_company).permit(:name, :website)
    end

    def save_as_favourite
      if session[:favourite_object_id].present? and current_user.present?
        building = Building.find(session[:favourite_object_id])
        current_user.favorite(building)
        session[:favourite_object_id] = nil
      end
    end
end
