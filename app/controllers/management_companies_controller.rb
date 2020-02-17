class ManagementCompaniesController < ApplicationController
  load_and_authorize_resource
  before_action :set_management_company,  only: [:show, :edit, :update, :destroy, :managed_buildings, :set_availability_link]
  before_action :save_as_favourite,       only: [:show]
  before_action :set_company_buildings,   only: [:show, :edit, :managed_buildings, :set_availability_link, :load_more_reviews]
  # GET /management_companies_url
  # GET /management_companies.json
  def index
    @management_companies = ManagementCompany.paginate(:page => params[:page], :per_page => 100)
  end

  def managed_buildings
    
  end

  def set_availability_link
    if params[:active_web].present?
      @buildings.update_all(active_web: params[:active_web])
    elsif params[:apply_link].present?
      @buildings.update_all(show_application_link: params[:apply_link])
    else
      @buildings.update_all(active_email: params[:active_email])
    end
    @management_company.update(updated_at: Time.zone.now)
  end

  def load_more_reviews
    @reviews = Review.where(reviewable_id:   @buildings.pluck(:id), 
                            reviewable_type: 'Building').includes(:user, :uploads, :reviewable)
    @reviews = @reviews.where('id < ?', params[:object_id]).limit(10) if params[:object_id].present?
    
    respond_to do |format|
      format.html{render nothing: true}
      format.js
    end
  end

  # GET /management_companies/1
  # GET /management_companies/1.json
  def show
    @show_map_btn        = @half_footer = true
    page_num             = params[:page].present? ? params[:page].to_i : 1
    final_results        = Building.with_featured_building(@buildings, page_num)
    @manage_buildings    = final_results[1] if !params[:object_id].present?
    @all_buildings       = final_results[0][:all_buildings]
    @recommended_percent = @management_company.recommended_percent(@buildings)
    @reviews             = Review.buildings_reviews(@buildings)
    @total_reviews       = @reviews.present? ? @reviews.count : 0
    @reviews             = @reviews.limit(10)
    if @buildings.present?
      @broker_percent = BrokerFeePercent.first.percent_amount
      @rent_medians   = RentMedian.all
      #finding average rating for all managed buildings 
      @stars = @management_company.get_average_stars(@buildings, @total_reviews)
      #For map
      @hash = final_results[0][:map_hash]
      if @hash.length > 0
        @lat = @hash.last['latitude']
        @lng = @hash.last['longitude']
      else
        @lat = @buildings.first.latitude
        @lng = @buildings.first.longitude
      end
      @zoom = 13 #buildings.length > 70 ? 13 : 11
    end
    @photos = Upload.building_photos(@all_buildings.map(&:id))
    @building_photos_count = @photos.size
    @meta_desc = "#{@management_company.name} manages #{@manage_buildings.count} no fee apartment, no fee rental, 
                  for rent by owner buildings in NYC you can rent directly from and pay no broker fees. 
                  Click to view #{@building_photos_count} photos and #{@total_reviews} reviews."
  end

  # GET /management_companies/new
  def new
    @management_company = ManagementCompany.new
  end

  # GET /management_companies/1/edit
  def edit
    @buildings = @manage_buildings = @buildings.paginate(:page => params[:page], :per_page => 20)
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

    def set_company_buildings
      @buildings = @management_company.company_buildings
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
