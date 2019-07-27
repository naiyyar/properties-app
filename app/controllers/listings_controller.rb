class ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  before_action :find_listings, only: [:change_status, :delete_all]
  # GET /listings
  # GET /listings.json
  def index
    @filterrific = initialize_filterrific(
      Listing,
      params[:filterrific],
      available_filters: [:search_query]
    ) or return
    @listings = @filterrific.find.paginate(:page => params[:page], :per_page => 100).includes(:building, building: [:management_company]) #.order(date_active: :desc, :management_company, :building_address, :unit)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def change_status
    @listings.update_all(active: params[:active])
    redirect_to :back
  end
  
  def delete_all
    @listings.destroy_all
    redirect_to :back
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
end
