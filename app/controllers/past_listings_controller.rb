class PastListingsController < ApplicationController
	before_action :set_listing, only: [:edit, :update, :destroy]

  include ListingsActionConcern
  
  def load_more
    @building = Building.find(params[:building_id])
    load_more_params = { date_active: params[:date_active], loaded_ids: params[:loaded_ids]}
    @past_listings = @building.get_listings(nil, 'past', load_more_params)
    respond_to do |format|
      format.html{
        redirect_back(fallback_location: building_path(@building))
      }
      format.js
    end
  end

  def transfer
  end

  def edit
  end

  def update
    respond_to do |format|
      if @listing.update(past_listing_params)
        format.html { redirect_to past_listings_url, notice: 'Listing was successfully updated.' }
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
      format.html { redirect_to past_listings_url, notice: 'Listing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  
  def set_listing
    @listing = PastListing.find(params[:id])
  end

  def past_listing_params
    params.require(:past_listing).permit!
  end

end
