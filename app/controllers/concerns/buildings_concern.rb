module BuildingsConcern
  extend ActiveSupport::Concern

  def show
    @show_map_btn     = @half_footer = true
    @distance_results = DistanceMatrix.get_data(@building) if Rails.env == 'production'
    broker_percent    = BrokerFeePercent.first.percent_amount
    @saved_amounts    = @building.saved_amount(RentMedian.all, broker_percent)
    @building_price   = @building.price
    @rating_cache     = @building.rating_cache?
    @price_ranges     = @building.price_ranges
    
    #building + units images
    @uploads               = @building.chached_image_uploads
    @uploaded_images_count = @uploads.size
    @documents             = @building.doc_uploads
    @reviews_count         = @building.reviews_count.to_i
    
    @lat                   = @building.latitude
    @lng                   = @building.longitude
    active_comps           = @building.active_comps
    @similar_properties    = Building.where(id: active_comps.pluck(:building_id))
                                    .includes(:building_average, :featured_buildings) if active_comps.present?
    buildings              = @similar_properties.to_a + [@building]
    @gmaphash              = Building.buildings_json_hash(buildings)
    @listings              = @building.listings
    @active_listings       = @listings.active.reorder(rent: :asc)
    @all_inactive_listings = @listings.inactive
    @inactive_listings     = @all_inactive_listings.reorder(date_active: :desc, rent: :asc).limit(5)

    @meta_desc = "#{@building.building_name if @building.building_name.present? } "+ 
                  "#{@building.building_street_address} is a #{@building.building_type if @building.building_type.present?} "+ 
                  "in #{@building.neighbohoods} #{@building.city} and is managed by #{@building.management_company.name if @building.management_company.present? }. "+ 
                  "Click to view #{@uploaded_images_count} photos and #{@reviews_count} reviews"
    
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
      if params[:building][:building_street_address].present? and params[:building][:zipcode].present?
        @building = Building.find_by_building_street_address_and_zipcode(params[:building][:building_street_address], params[:building][:zipcode])
      elsif params[:building][:building_street_address].present?
        @building = Building.find_by_building_street_address(params[:building][:building_street_address])
      else
        @building = Building.find_by_building_street_address(params['buildings-search-txt'])
      end
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

end