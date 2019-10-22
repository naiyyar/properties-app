class ListingsController < ApplicationController
  load_and_authorize_resource only: [:index, :export]
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  before_action :find_listings, only: [:change_status, :delete_all]
  after_action :update_building_rent, only:[:create, :update, :destroy]
  # GET /listings
  # GET /listings.json
  def index
    @filterrific = initialize_filterrific(
      Listing,
      params[:filterrific],
      available_filters: [:default_listing_order, :search_query]
    ) or return
    @listings = @filterrific.find.paginate(:page => params[:page], :per_page => 100)
                                 .includes(:building, building: [:management_company]).default_listing_order

    respond_to do |format|
      format.html
      format.js
    end
  end

  def change_status
    #Issue: Counter cache doesn't work with update_all
    #@listings.update_all(active: params[:active])
    @listings.each do |listing|
      listing.update(active: params[:active])
    end
    redirect_to :back
  end
  
  def delete_all
    #Issue: Counter cache doesn't work with destroy_all
    #@listings.destroy_all
    @listings.each do |listing|
      listing.destroy
      listing.update_rent
    end
    redirect_to :back
  end

  def import
    @errors = Listing.import_listings(params[:file])
    if @errors.present?
      flash[:error] = @errors
    else
      flash[:notice] = 'File Succesfully Imported.'
    end
    redirect_to :back
  end

  def export
    @from_date = Date.parse(params[:date_from])
    @to_date = params[:date_to].present? ? Date.parse(params[:date_to]) : (@from_date + 1.month)
    @listings = Listing.where('date_active >= ? AND date_active <= ?', @from_date, @to_date)
    
    case params[:format]
      when "xls" then render xls: 'export'
      when "xlsx" then render xlsx: 'export'
      when "csv" then render csv: 'export'
      else render action: "index"
    end
  end

  def show_more
    @building = Building.find(params[:building_id])
    unless params[:listing_type].present?
      @listings = @building.listings
      order = {date_active: :desc, rent: :asc}
      @rentals = 'past'
    else
      @listings = @building.listings.active
      @rentals = 'active'
      order = {rent: :asc}
    end
    @listings = @listings.reorder(order)
  end

  # GET /listings/1
  # GET /listings/1.json
  def show
  end

  # GET /listings/new
  def new
    @listing = Listing.new
  end

  # GET /listings/1/edit
  def edit
  end

  # POST /listings
  # POST /listings.json
  def create
    @listing = Listing.new(listing_params)

    respond_to do |format|
      if @listing.save
        format.html { redirect_to listings_url, notice: 'Listing was successfully created.' }
        format.json { render :show, status: :created, location: @listing }
      else
        format.html { render :new }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listings/1
  # PATCH/PUT /listings/1.json
  def update
    respond_to do |format|
      if @listing.update(listing_params)
        format.html { redirect_to listings_url, notice: 'Listing was successfully updated.' }
        format.json { render :json => { success: true, data: @listing } }
      else
        format.html { render :edit }
        format.json { render json: @listing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1
  # DELETE /listings/1.json
  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url, notice: 'Listing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def listing_params
      params.require(:listing).permit(:building_id,:unit,:building_id,
                                      :rent,:bed,:bath,:free_months,:owner_paid,
                                      :date_available,:rent_stabilize,:active,
                                      :building_address, :management_company,
                                      :date_active)
    end

    def find_listings
      @listings = Listing.where(id: params[:selected_ids])
    end

    def update_building_rent
      @listing.update_rent
    end
end
