class ListingsController < ApplicationController
  load_and_authorize_resource                 only: [:index, :export]
  before_action :set_listing,                 only: [:show, :edit, :update, :destroy]
  before_action :find_listings,               only: [:change_status, :delete_all, :transfer_all]
  before_action :format_date,                 only: [:transfer, :export]
  before_action :find_listings_between_dates, only: [:transfer, :export]
  before_action :filter_listings,             only: :index
  before_action :set_building,                only: :show_more
  after_action :update_building_rent,         only:[:create, :update, :destroy]
  
  def index
    @export_listings_path = export_listings_path
    @type = 'current'
    respond_to do |format|
      format.html
      format.js
    end
  end

  def change_status
    @listings.includes(:building).each do |list|
      building = list.building
      list.update_column('active', params[:active])
      building.update_rent(building.listings.active)
    end
    redirect_to :back
  end
  
  def delete_all
    unless params[:type] == 'past'
      Listing.delete_current_listings(@listings)
    else
      @listings.delete_all
    end
    redirect_to :back
  end

  def transfer_all
    if @listings.present?
      Listing.transfer_to_past_listings_table(@listings)
    else
      flash[:error] = 'Please select the listings to transfer.'
    end
    redirect_to :back
  end

  def import
    buildings      = Building.where.not(building_street_address: nil).includes(:listings)
    import_listing = ImportListing.new(params[:file])
    @errors        = import_listing.import_listings(buildings)
    if @errors.present?
      flash[:error] = @errors
    else
      flash[:notice] = 'File Succesfully Imported.'
    end
    redirect_to :back
  end

  def transfer
    if @listings.present?
      TransferListingsJob.perform_later(params[:date_from], params[:date_to])
      flash[:notice] = 'Transfering Listings To Past Listings Table started.'
    else
      #if @listings.present?
      #  Listing.transfer_to_past_listings_table(@listings)
      #  flash[:notice] = 'Transfering listings completed.'
      #else
      flash[:error] = ["No Listings found between #{params[:date_from]} and #{params[:date_to]}."]
      #end
    end
    redirect_to :back
  end

  def export
    file_name = "Listings_#{params[:date_from]}_to_#{params[:date_to]}.#{params[:format]}"
    case params[:format]
      when 'xls'  then render xls:  'export'
      when 'xlsx' then render xlsx: 'export', filename: file_name
      when 'csv'  then render csv:  'export'
      else render action: 'index'
    end
  end

  def show_more
    @rentals             = params[:listing_type] || 'active'
    @listings            = @building.get_listings(params[:filter_params], @rentals)
    @listings_count = if @rentals == 'past' 
                        @building.past_listings.count
                      else
                        @building.listings.count
                      end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def show
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

    # Never trust parameters from the scary internet, only allow the white list through.
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
      building.update_rent(building.listings.active)
    end

    def set_building
      @building = Building.find(params[:building_id])
    end

    def filter_listings
      @filterrific = initialize_filterrific(
        Listing,
        params[:filterrific],
        available_filters: [:default_listing_order, :search_query]
      ) or return
      @listings = @filterrific.find.paginate(:page => params[:page], :per_page => 100)
                                   .includes(building: [:management_company])
                                   .default_listing_order
    end

    def format_date
      @from_date = Date.parse(params[:date_from])
      @to_date   = params[:date_to].present? ? Date.parse(params[:date_to]) : (@from_date + 1.month)
    end

    def find_listings_between_dates
      @listings = Listing.between(@from_date, @to_date)
    end
end
