class BuildingsController < ApplicationController 
  before_action :authenticate_user!, except: [:index, :show, :contribute,:create,:edit, :autocomplete, :apt_search]

  def index
    @buildings = Building.order('created_at desc')
    respond_to do |format|
      format.html
      format.json { 
        render json: Building.search(params[:term])
      }
    end
  end

  def units
    @building = Building.find(params[:id])
    @units = @building.units
  end

  def contribute
    @buildings = Building.text_search(params[:term]).reorder('building_street_address ASC')
    @building = Building.where(id: params[:building_id]).first if params[:building_id].present?
    @search_bar_hidden = :hidden
  end

  def show
    @building = Building.find(params[:id])

    @unit_rent_summary_count = @building.unit_rent_summary_count
    @unit_review_count = @building.unit_reviews_count
    
    @reviews = @building.reviews.order(created_at: :desc)
    @uploads = Upload.where("imageable_id = ? or imageable_id in (?)", @building.id, @building.units.map{|u| u.id})

    #calculating unit reviews count for a building
    @building_units = @building.units
    @unit_review_count = 0
    @building_units.each do |unit|
      @unit_review_count += unit.reviews.count
    end

    @lat = @building.latitude
    @lng = @building.longitude

    @gmaphash = [
                  {
                    title: @building.building_name,
                    image: Upload.marker_image(@building),
                    address: @building.street_address,
                    position: {
                      lat: @building.latitude,
                      lng: @building.longitude
                    },
                    markerIcon: ActionController::Base.helpers.asset_path("marker-blue.png")

                  }
                ]
    
    #google Map
    # @hash = Gmaps4rails.build_markers(@building) do |building, marker|
    #   marker.lat building.latitude
    #   marker.lng building.longitude
    #   building_link = view_context.link_to building.building_name, building_path(building)
    #   marker.title building.building_name
    #   marker.infowindow render_to_string(:partial => "/layouts/shared/marker_infowindow", 
    #                                      :locals => { building_link: building_link, 
    #                                                   building: building,
    #                                                   image: Upload.marker_image(@building)
    #                                                 }
    #                                     )
    
    #   #To add own marker
    #   marker.picture ({
    #         "url" => ActionController::Base.helpers.asset_path("marker-blue.png"),
    #         "width" => 50,
    #         "height" => 50
    #         })
    # end
  end

  def new
    if params['buildings-search-txt'].present?
      @building = Building.find_by_building_street_address(params['buildings-search-txt'])
    else
      @building = Building.new
    end
    
  end

  def create
    if current_user.nil?
      # case params[:contribution]
      # when 'building_photos'
      #   session[:contribution_for] = 'building_photos'
      # when 'building_amenities'
      #   session[:contribution_for] = 'building_amenities'
      # when 'unit_photos'
      #   session[:contribution_for] = 'unit_photos'
      # when 'unit_amenities'
      #   session[:contribution_for] = 'unit_amenities'
      # end
      # Store the form data in the session so we can retrieve it after login
      session[:form_data] = params
      session[:object_type] = params[:unit_contribution].present? ? 'unit' : 'building'
      # Redirect the user to register/login
      redirect_to new_user_session_path
    else
      if params[:building][:building_street_address].present?
        @building = Building.find_by_building_street_address(params[:building][:building_street_address])
      else
        @building = Building.find_by_building_street_address(params['buildings-search-txt'])
      end
      if @building.blank?
        @building = Building.create(building_params)

        if @building.save
          flash[:notice] = "Building Created."
          if params[:unit_contribution]
            contribute = params[:unit_contribution]
            unit_id = @building.units.last.id
          else
            contribute = params[:contribution]
            building_id = @building.id
          end
          if contribute.present?
            if ['unit_review', 'unit_photos', 'unit_amenities', 'unit_price_history'].include? contribute
              redirect_to contribute_buildings_path(contribution_for: contribute, building_id: @building.id)  
            else
              redirect_to user_steps_path(building_id: building_id, unit_id: unit_id, contribution_for: contribute)
            end
          else
            redirect_to building_steps_path(building_id: @building.id)
          end
          
        else
          flash.now[:error] = "Error Creating"
          render :new
        end
      else
        if params[:unit_id].present?
          @unit = Unit.find(params[:unit_id])
          @unit.update(unit_params)
        else
          if params[:building][:units_attributes].present?
            @unit = @building.fetch_or_create_unit(params[:building][:units_attributes])
          end
        end
        if params[:unit_contribution]
          contribute = params[:unit_contribution]
          unit_id = @unit.id
        else
          contribute = params[:contribution]
          building_id = @building.id
        end
        redirect_to user_steps_path(building_id: building_id, unit_id: unit_id, contribution_for: contribute)
      end
    end
  end

  def edit
    @building = Building.find(params[:id])
    @search_bar_hidden = :hidden
  end

  def update
    @building = Building.find(params[:id])
    if @building.update(building_params)
      if params[:subaction].blank?
        redirect_to building_path(@building), notice: "Successfully Updated"
      else
        redirect_to building_steps_path(building_id: @building.id)
      end
    else
      flash.now[:error] = "Error Updating"
      render :edit
    end
  end

  def destroy
    @building = Building.find(params[:id])
    @building.destroy

    redirect_to buildings_path, notice: "Successfully Deleted"
  end

  private


  def building_params
    params.require(:building).permit(:neighborhood,:building_name,:user_id, :building_street_address, :photo, :latitude, :longitude,:city,:state,:phone, :zipcode, :address2,:weburl,
                                      :pets_allowed,:laundry_facility,:parking,:doorman,:elevator,:description,:floors,:built_in,:number_of_units,
                                      :deck,:elevator,:garage,:gym,:live_in_super,:pets_allowed_cats,:pets_allowed_dogs,:roof_deck,:swimming_pool,:walk_up,
                                      uploads_attributes:[:id,:image,:imageable_id,:imageable_type], 
                                      units_attributes: [:id, :building_id, :name, :square_feet, :number_of_bedrooms, :number_of_bathrooms])
  end

  def unit_params
    params[:unit] = params[:building][:units_attributes]['0']
    params.require(:unit).permit(:name, :square_feet, :number_of_bathrooms, :number_of_bedrooms)
  end

end