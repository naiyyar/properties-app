class FeaturedListingsController < ApplicationController
	before_action :set_featured_listing, only: [:show, :update, :destroy]
  
  include Searchable
  
  def index
  	@featured_listings = filterrific_search_results

  	respond_to do |format|
      format.html
      format.js
    end
  end

  def show
  end

  def new
    @featured_listing = FeaturedListing.new
  end

  def edit
    # @featured_listing = FeaturedListing.find(session[:rental_listing_id])
  end

  def create
    @featured_listing = FeaturedListing.new(rental_listing_params)

    respond_to do |format|
      if @featured_listing.save
        # session[:rental_listing_id] = @featured_listing.id
        format.html { redirect_to featured_listing_steps_path(featured_listing_id: @featured_agent.id) }
      else
        format.html { 
          flash[:error] = @featured_listing.errors.full_messages
          redirect_to :back 
        }
      end
    end
  end

  def update
    respond_to do |format|
      if @featured_listing.update(featured_listing_params)
        # session[:rental_listing_id] = @featured_listing.id
        format.html { redirect_to featured_listing_steps_path(featured_listing_id: @featured_agent.id) }
      else
        format.html { 
          flash[:error] = @featured_listing.errors.full_messages
          redirect_to :back 
        }
      end
    end
  end

  def destroy
    @featured_listing.destroy
    respond_to do |format|
      format.html { redirect_to :back, notice: 'Featured listing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_featured_listing
      @featured_listing = FeaturedListing.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def featured_listing_params
      params.require(:featured_listing).permit!
    end
end
