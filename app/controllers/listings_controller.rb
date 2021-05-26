class ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :edit, :update, :destroy]
  before_action :find_listings, only: [:change_status, :delete_all, :transfer_all]
  after_action :update_building_rent, only:[:create, :update, :destroy]
  
  include ListingsActionConcern

  def change_status
    @listings.includes(:building).each do |list|
      building = list.building
      list.update(active: params[:active])
      building.update_rent(building.listings.active)
    end
    
    redirect_back(fallback_location: listings_path)
  end
  
  def delete_all
    unless params[:type] == 'past'
      Listing.delete_current_listings(@listings)
    else
      @listings.delete_all
    end
    redirect_back(fallback_location: listings_path)
  end

  def transfer_all
    if @listings.present?
      Listing.transfer_to_past_listings_table(@listings)
    else
      flash[:error] = 'Please select the listings to transfer.'
    end
    redirect_back(fallback_location: listings_path)
  end

  def import
    buildings = Building.where.not(building_street_address: nil).includes(:listings)
    import_listing = ImportListing.new(params[:file])
    @errors = import_listing.import_listings(buildings)
    if @errors.present?
      flash[:error] = @errors
    else
      flash[:notice] = 'File Succesfully Imported.'
    end
    redirect_back(fallback_location: listings_path)
  end

  def transfer
    if @listings.present?
      TransferListingsJob.perform_later(params[:date_from], params[:date_to])
      flash[:notice] = 'Transfering Listings To Past Listings Table started.'
    else
      flash[:error] = ["No Listings found between #{params[:date_from]} and #{params[:date_to]}."]
    end
    redirect_back(fallback_location: listings_path)
  end

  def new
    @listing = Listing.new
  end

  def edit
  end

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

  def destroy
    @listing.destroy
    respond_to do |format|
      format.html { redirect_to listings_url, notice: 'Listing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  
  def set_listing
    @listing = Listing.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(:building_id,:unit,:building_id,
                                    :rent,:bed,:bath,:free_months,:owner_paid,
                                    :date_available,:rent_stabilize,:active,
                                    :building_address, :management_company,
                                    :date_active)
  end

  def find_listings
    @listings = if params[:type] == 'past'
                  PastListing.where(id: params[:selected_ids])
                else
                  Listing.where(id: params[:selected_ids])
                end
  end

  def update_building_rent
    building = @listing.building
    building.update_rent(building.listings)
  end
end
