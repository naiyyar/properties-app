class PastListingsController < ApplicationController
	load_and_authorize_resource   	only: [:index, :export]
	before_action :set_listing,   	only: [:show, :edit, :update, :destroy]
	before_action :filter_listings, only: :index
	before_action :format_date, 		only: :export
  
  def index
  	@export_listings_path = export_past_listings_path
    @type = 'past'
  	respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
  end

  def export
    @listings = PastListing.between(@from_date, @to_date)
    file_name = "Past_listings_#{params[:date_from]}_to_#{params[:date_to]}.#{params[:format]}"
    case params[:format]
      when 'xls'  then render xls:  'export'
      when 'xlsx' then render xlsx: 'export', filename: file_name
      when 'csv'  then render csv:  'export'
      else render action: 'index'
    end
  end

  def update
    respond_to do |format|
      if @listing.update(listing_params)
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

  def filter_listings
      @filterrific = initialize_filterrific(
        PastListing,
        params[:filterrific],
        available_filters: [:default_listing_order, :search_query]
      ) or return
      @listings = @filterrific.find.paginate(:page => params[:page], :per_page => 100)
                                   .includes(:building, building: [:management_company])
                                   .default_listing_order
    end

  def format_date
    @from_date = Date.parse(params[:date_from])
    @to_date   = params[:date_to].present? ? Date.parse(params[:date_to]) : (@from_date + 1.month)
  end
end
