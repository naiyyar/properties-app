module BuildingsConcern
  extend ActiveSupport::Concern

  included do
    before_action :save_as_favourite,              only: :show
    before_action :get_building,                   only: :create
    before_action :get_uploads, :set_image_counts, only: :show
  end

  def show
    @half_footer = true
    # reviews
    @reviews_count = @building.reviews_count.to_i
    # comps
    @similar_properties       = @building.comps
    @similar_properties_count = @similar_properties.length
    # 
    @gmaphash = Building.buildings_json_hash(@similar_properties.to_a + [@building])
    # Current listings
    @listings              = @building.listings
    @active_listings       = @listings.active.order_by_rent_asc
    @building.act_listings = @active_listings
    @active_listings_count = @active_listings.count
    # Past listings
    @past_listings         = @building.past_listings
    @last5_past_listings   = @past_listings.order_by_date_active_desc.limit(5)
    @past_listings_count   = @past_listings.count
    # Tour
    @building_tours        = @building.video_tours
    @video_tours, @category = VideoTour.videos_by_categories(@building_tours, limit: 2)
    
    @neighbohood            = @building.neighbohoods
    @nearby_nbs             = NYCBorough.nearby_neighborhoods(@building.nearby_neighborhood)

    @reviews       = @building.building_reviews
    @price_ranges  = @building.price_ranges
    broker_percent = BrokerFeePercent.first.percent_amount
    @saved_amounts = @building.broker_fee_savings(RentMedian.all, broker_percent)
    @distance_results = DistanceMatrix.new(@building).get_data
    
    @meta_desc  = "#{@building.building_name_or_address} #{@building.building_street_address} is a #{@building.try(:building_type)} "+ 
                  "in #{@building.neighbohoods} #{@building.city} and is managed by #{@building.management_company.try(:name) }. "+ 
                  "View #{@uploaded_images_count} photos, #{@active_listings_count} active listings, #{@past_listings_count} past listings."
    
    flash[:notice] = 'Files are uploaded successfully.' if params[:from_uploaded].present?
  end

  def create
    if current_user.nil?
      # Store the form data in the session so we can retrieve it after login
      session[:form_data] = params
      session[:object_type] = params[:unit_contribution].present? ? 'unit' : 'building'
      # Redirect the user to register/login
      redirect_to new_user_registration_path
    else
      if @building.blank?
        @building = Building.create(building_params)
        if @building.save
          if params[:unit_contribution]
            contribute = params[:unit_contribution]
            unit_id = @building.units.last.id
          else
            contribute = params[:contribution]
          end
          flash[:notice] = 'Building Created.'
          if contribute.present?
            if ['unit_review', 'unit_photos', 'unit_amenities', 'unit_price_history'].include? contribute
              redirect_to contribute_buildings_path(contribution_for: contribute, building_id: @building.id, contribution: contribute)  
            else
              redirect_to user_steps_path(building_id: @building.id, unit_id: unit_id, contribution_for: contribute, contribution: contribute)
            end
          else
            redirect_to building_steps_path(building_id: @building.id)
          end
          
        else
          flash.now[:error] = 'Error Creating'
          render :new
        end
      else
        if params[:unit_id].present?
          @unit = Unit.find(params[:unit_id])
          @unit.update(unit_params)
        else
          if params[:building][:units_attributes].present?
            @unit = @building.fetch_or_create_unit(building_params)
          end
        end
        if params[:unit_contribution]
          contribute = params[:unit_contribution]
          unit_id = @unit.id
        else
          contribute = params[:contribution]
          building_id = @building.id
        end
        if params[:page].present?
          redirect_to unit_path(@unit)
        else
          redirect_to user_steps_path(building_id: @building.id, unit_id: unit_id, contribution_for: contribute)
        end
      end
    end
  end

  private
  def get_neighborhood
    @building.get_and_save_neighborhood(params[:selected_manually])
  end

  def save_as_favourite
    return unless session[:favourite_object_id].present? && current_user.present?
    current_user.add_to_fav(session[:favourite_object_id])
    session[:favourite_object_id] = nil
  end
  
  def get_building
    address     = params[:building][:building_street_address]
    zipcode     = params[:building][:zipcode]
    search_term = params['buildings-search-txt']
    @building = if address.present? && zipcode.present?
                  Building.where(building_street_address: address, zipcode: zipcode).first
                elsif address.present?
                  Building.find_by_building_street_address(address)
                else
                  Building.find_by_building_street_address(search_term)
                end
  end

  def get_uploads
    assets                 = @building.get_uploads
    @uploads, @documents   = assets[:image_uploads], assets[:doc_uploads]
  end

  def set_image_counts
    @uploaded_images_count = @building.uploads_count.to_i
  end

end