class FeaturedListingsController < ApplicationController
	load_and_authorize_resource
  before_action :authenticate_user!, except: [:show, :contact_owner]
  before_action :set_featured_listing, only: [:show, :update, :destroy, :contact_owner]
  
  include Searchable
  
  def index
  	@featured_listings = filterrific_search_results.includes([:user])
  	respond_to do |format|
      format.html
      format.js
    end
  end

  def contact_owner
    respond_to do |format|
      format.html { 
        UserMailer.contact_frbo(@featured_listing, params[:contact_owner]).deliver
        UserMailer.send_frbo_email_to_renter(@featured_listing, params[:contact_owner]).deliver
        redirect_to :back, notice: '' 
      }
      format.js
    end
  end

  def show
    @half_footer = true
    @featured_listing_tours = @featured_listing.video_tours
    @video_tours_count = @featured_listing_tours.size
    @neighborhood = @featured_listing.neighborhood1
    @nearby_nbs = NYCBorough.nearby_neighborhoods(@neighborhood)
    @uploaded_images_count = @featured_listing.uploads_count
    @distance_results = DistanceMatrixService.new(@featured_listing).get_data
    @gmaphash = [@featured_listing.as_json] # for map
    @meta_desc = meta_description
  end

  def new
    session[:back_to] = request.fullpath if params[:type] != 'billing'
    @featured_by    = params[:featured_by] 
    @featured_listing = FeaturedListing.new
    @object_id      = params[:object_id]
    @object_type    = 'FeaturedListing'
    @price          = Billing::FEATURED_PRICES[@object_type]
    @saved_cards    = BillingService.new(current_user).get_saved_cards rescue nil
  end

  def edit
    
  end

  def create
    @featured_listing = FeaturedListing.new(featured_listing_params)

    respond_to do |format|
      if @featured_listing.save
        format.html { 
          redirect_to next_step_url(:create) 
        }
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
        format.html { redirect_to next_step_url(params[:next_step]) }
        format.json { render json: @featured_listing }
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
      params.require(:featured_listing).permit(:first_name, 
                                               :last_name, 
                                               :email, 
                                               :phone, 
                                               :neighborhood, 
                                               :address, 
                                               :unit, 
                                               :city, 
                                               :state, 
                                               :zipcode, 
                                               :rent, 
                                               :bed, 
                                               :bath, 
                                               :size, 
                                               :apartment_type, 
                                               :date_available, 
                                               :description, 
                                               :user_id, 
                                               :start_date, 
                                               :end_date, 
                                               :featured_by, 
                                               :uploads_count, 
                                               :active, 
                                               :renew, 
                                               :latitude, 
                                               :longitude, 
                                               :amenities, 
                                               :neighborhood1)
    end

    def next_step_url step
      view_context.next_prev_step_url(@featured_listing, step: step)
    end

    # [Address] [Unit Number] is a [#] Bed [#] Bath apartment for rent in a  [Apartment Type] 
    # in [Neighborhood] for $[Monthly Rent] and is managed by [First Name] [Last Initial].
    def meta_description
      "#{@featured_listing.address_with_unit} is a #{@featured_listing.bed} Bed" +
      " #{@featured_listing.bath} Bath apartment for rent in a #{@featured_listing.apartment_type} in" +
      " #{@neighborhood} for $#{@featured_listing.rent} and is managed by #{@featured_listing.name_with_last_initial}."
    end
end
