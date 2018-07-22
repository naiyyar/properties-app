class ManagementCompaniesController < ApplicationController
  load_and_authorize_resource
  before_action :set_management_company, only: [:show, :edit, :update, :destroy]

  # GET /management_companies
  # GET /management_companies.json
  def index
    @management_companies = ManagementCompany.all
  end

  # GET /management_companies/1
  # GET /management_companies/1.json
  def show
    @manage_buildings = @management_company.buildings
    if @manage_buildings.present?
      #finding average rating for all managed buildings 
      @total_rates = 0
      @stars = []
      buildings_count = @manage_buildings.count
      @manage_buildings.each do |building|
        rating_cache = building.rating_cache
        if rating_cache.present?
          @total_rates += rating_cache.first.avg if rating_cache.present?
        end
      end
      @stars = (@total_rates.to_f/buildings_count).round(2).to_s.split('.')
      
      #For Gmap
      @lat = @manage_buildings.first.latitude
      @lng = @manage_buildings.first.longitude
      @manage_buildings = @manage_buildings.includes(:uploads, :units, :building_average, :votes) unless @manage_buildings.kind_of? Array
      @hash = Gmaps4rails.build_markers(@manage_buildings) do |building, marker|
        marker.lat building.latitude
        marker.lng building.longitude
        marker.title "#{building.id}, #{building.building_name}, #{building.street_address}, #{building.zipcode}"
        
        marker.infowindow render_to_string(:partial => "/layouts/shared/marker_infowindow", 
                                           :locals => { 
                                                        building: building,
                                                        image: Upload.marker_image(building)
                                                      }
                                          )
      end
    end
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
end
