class UsersController < ApplicationController
	load_and_authorize_resource :find_by => :slug 
	
	before_action :authenticate_user!, only: [:show, :edit, :saved_buildings, :featured_listings_steps]
	before_action :set_user, 					 except: [:index, :create]
	before_action :get_saved_cards, :set_type_and_back_to_url, only: [:managertools, :agenttools, :frbotools]

	def index
		@pagy, @users = pagy(User.order('created_at desc').includes(:buildings, :favorites), items: 100)
	end

	def contribution
	end

	def featured_listings_steps
    @featured_listing = FeaturedListing.find(params[:object_id])
    if current_user == @featured_listing.user
      @partial_to_render = params[:step]
      @step = @partial_to_render.to_sym
      @partial_to_render = 'form' if @step == :create
      case @step
      when :add_amenities
        @listing_amenities = @featured_listing.amenities
      when :add_photos
        @imageable = @featured_listing
        @new_video_tour = VideoTour.new
        @video_tours = @imageable.video_tours.where(category: 'featured_listing')
        @photos = @imageable.uploads.with_image.includes([:imageable, :user])
        session[:back_to] = request.fullpath
      when :payment
        @object      = @featured_listing
        @featured_by = 'manager'
        @object_id   = @featured_listing.id
        @object_type = 'FeaturedListing'
        @price       = Billing::FEATURED_PRICES[@object_type]
        @saved_cards = BillingService.new(current_user).get_saved_cards rescue nil
      end
    else
    	redirect_to '/403' # access denied
    end
  end

	def saved_buildings
		# @rent_medians 	= RentMedian.all
		# @broker_percent = BrokerFeePercent.first.percent_amount
		@pagy, @buildings = pagy(Building.saved_favourites(@user).includes(:featured_buildings))
    @photos = Upload.building_photos(@buildings.pluck(:id))
		@hash = Building.buildings_json_hash(@buildings)
    @zoom = 12
    @show_map_btn = @half_footer = true
	end

	def managertools
		unless @type == 'billing'
			@pagy, @featured_buildings = pagy(filterific_results(FeaturedBuilding).includes(:billings, 
																																											:building => [:management_company]
																																											), items: 100)
	  else
	  	@billings = get_billings_for('FeaturedBuilding')
	  end

    respond_to do |format|
      format.html
      format.js
    end
	end

	def agenttools
		unless @type == 'billing'
			@pagy, @featured_agents = pagy(filterific_results(FeaturedAgent), items: 100)
	  	@photos_count = @featured_agents.sum(:uploads_count)
	  else
	  	@billings = get_billings_for('FeaturedAgent')
	  end
    
    respond_to do |format|
      format.html
      format.js
    end
	end

	def frbotools
		unless @type == 'billing'
			@pagy, @featured_listings = pagy(filterific_results(FeaturedListing).includes(:user), items: 100)
	  	@photos_count = @featured_listings.sum(:uploads_count)
	  else
	  	@billings = get_billings_for('FeaturedListing')
	  end
    
    respond_to do |format|
      format.html
      format.js
    end
	end

	def new
	end

	def show
		
	end

	def edit
		@pagy, @buildings = pagy(@user.buildings.includes(:uploads))
	end

	def create
	end

	def update
		if @user.update_attributes(user_params)
			redirect_to edit_user_path(@user), notice: 'User updated successfully'
		else
			flash[:error] = @user.errors.messages.values[0][0]
			redirect_back(fallback_location: user_path(@user))
		end
	end

	def destroy
	end


	private

	def set_user
		@user = current_user || User.friendly.find(params[:id])
	end

	def user_params
		params.require(:user).permit(:name, :phone, :mobile, :about_me, :email, :avatar)
	end

	def get_saved_cards
		if params[:type] == 'billing'
			@saved_cards = BillingService.new(current_user).get_saved_cards
		end
	end

	def get_billings_for model_type
		@pagy, billings = pagy(@current_user.billings.for_type(model_type), items: 100)
		return billings
	end

	def set_type_and_back_to_url
		@type = params[:type]
		session[:back_to] = request.fullpath
	end

	def filterific_results model_klas
		@filterrific = initialize_filterrific(
	      model_klas,
	      params[:filterrific],
	      available_filters: [:search_query]
	    ) or return

    return @filterrific.find
							  			 .where(user_id: @user.id).by_manager
							  			 .order('created_at desc')
	end
end