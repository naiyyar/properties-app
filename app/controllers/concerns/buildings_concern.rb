module BuildingsConcern
  extend ActiveSupport::Concern

  def show
    @show_map_btn          = @half_footer = true
    @price_ranges          = @building.price_ranges
    @uploads               = @building.chached_image_uploads
    @uploaded_images_count = @building.uploads_count.to_i
    @documents             = @building.doc_uploads
    @reviews               = @building.building_reviews.includes(:uploads)
    @reviews_count         = @building.reviews_count.to_i
    active_comps           = @building.active_comps
    @similar_properties    = Building.where(id: active_comps.pluck(:building_id))
                                    .includes(:featured_comps, :uploads) if active_comps.present?
    buildings              = @similar_properties.to_a + [@building]
    @gmaphash              = Building.buildings_json_hash(buildings)
    @listings              = @building.listings
    @active_listings       = @listings.active.order_by_rent_asc
    @all_inactive_listings = @building.past_listings
    @inactive_listings     = @all_inactive_listings.order_by_date_active_desc.limit(5)
    @building_tours        = @building.video_tours
    @video_tours, @category = VideoTour.videos_by_categories(@building_tours, limit: 2)
    @neighbohood            = @building.neighbohoods
    @nearby_nbs             = NYCBorough.nearby_neighborhoods(@neighbohood)
    @meta_desc  = "#{@building.building_name_or_address} #{@building.building_street_address} is a #{@building.try(:building_type)} "+ 
                  "in #{@building.neighbohoods} #{@building.city} and is managed by #{@building.management_company.try(:name) }. "+ 
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