class BuildingsController < ApplicationController 
  load_and_authorize_resource
  before_action :authenticate_user!, except: [:index, :show, :contribute, :create, :autocomplete, :apt_search]
  after_action :add_or_update_prices, only: [:create, :update]
  def index
    @filterrific = initialize_filterrific(
      Building,
      params[:filterrific],
      # select_options: {
      #   sorted_by: Building.options_for_sorted_by,
      # },
      available_filters: [:search_query]
    ) or return
    @buildings = @filterrific.find.paginate(:page => params[:page], :per_page => 100).includes(:building_average).reorder('created_at desc') #.sorted_by(params[:sorted_by])

    respond_to do |format|
      format.html
      format.js
    end
  end

  def favorite
    @building = Building.find(params[:object_id])
    current_user.favorite(@building)
    respond_to do |format|
      format.js
    end
  end

  def unfavorite
    @building = Building.find(params[:object_id])
    current_user.unfavorite(@building)
    
    render json: { message: 'Success' }
  end

  def units
    @building = Building.find(params[:id])
    @units = @building.units
  end

  #disconnecting building from a management company
  def disconnect_building
    Building.where(id: params[:id]).update_all(management_company_id: nil)
    redirect_to :back, notice: 'Building disconnected'
  end

  def contribute
    session[:form_data] = nil if session[:form_data].present?
    if params[:management].present?
      @buildings = Building.where('management_company_id is null')
    else
      @buildings = Building.all
    end
    @buildings = @buildings.text_search(params[:term]).reorder('building_street_address ASC').limit(10).includes(:units)
    @building = Building.where(id: params[:building_id]).first if params[:building_id].present?
    @search_bar_hidden = :hidden
  end

  def import
    Building.import_reviews(params[:file])
    redirect_to :back, notice: 'File imported.'
  end

  def show
    @building = Building.find(params[:id])
    #@buiding_uploads = @building.image_uploads.includes(:imageable)
    #@unit_rent_summary_count = @building.unit_rent_summary_count
    #@unit_review_count = @building.unit_reviews_count
    @show_map_btn = true
    @reviews = @building.reviews.includes(:user, :uploads, :reviewable).order(created_at: :desc)
    
    #building + uinits images
    @uploads = @building.image_uploads

    #calculating unit reviews count for a building
    # @building_units = @building.units
    # @unit_review_count = 0
    # @building_units.each do |unit|
    #   @unit_review_count += unit.reviews.count
    # end

    @documents = @building.uploads.where('document_file_name is not null')

    @lat = @building.latitude
    @lng = @building.longitude

    @gmaphash = [
                  {
                    id: @building.id,
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

    @meta_desc = "#{@building.building_name if @building.building_name.present? } "+ 
                  "#{@building.building_street_address} is a #{@building.building_type if @building.building_type.present?} "+ 
                  "in #{@building.neighbohoods} #{@building.city} and is managed by #{@building.management_company.name if @building.management_company.present? }. "+ 
                  "Click to view #{@uploads.count} photos and #{@building.reviews.count} reviews"
    
    flash[:notice] = "Files are uploaded successfully." if params[:from_uploaded].present?
  end

  def new
    if params['buildings-search-txt'].present?
      @building = Building.find_by_building_street_address(params['buildings-search-txt'])
      if @building.blank?
        address = params['buildings-search-txt'].split(',')[0]
        @building = Building.find_by_building_street_address(address)
      end
    else
      @building = Building.new
    end
    
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
            #building_id = @building.id
          end
          flash[:notice] = "Building Created."
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
          flash.now[:error] = "Error Creating"
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

  def edit
    @building = Building.find(params[:id])
    #@search_bar_hidden = :hidden
  end

  def update
    @building = Building.find(params[:id])
    if @building.update(building_params)
      session[:after_contribute] = 'amenities' if params[:contribution].present?
      if params[:subaction].blank?
        redirect_to building_path(@building), notice: "Successfully Updated"
      else
        redirect_to building_path(@building)
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
    params.require(:building).permit! 
                                      # (:neighborhood,:building_name,:user_id, :building_street_address, :photo, :latitude, :longitude,:city,:state,:phone, :zipcode, :address2,:weburl,
                                      # :pets_allowed,:laundry_facility,:parking,:doorman,:elevator,:description,:floors,:built_in,:number_of_units,:web_url, :building_type,
                                      # :management_company_run,:courtyard,:elevator,:garage,:gym,:live_in_super,:pets_allowed_cats,:pets_allowed_dogs,:roof_deck,:swimming_pool,:walk_up,
                                      # uploads_attributes:[:id,:image,:imageable_id,:imageable_type], 
                                      # units_attributes: [:id, :building_id, :name, :square_feet, :number_of_bedrooms, :number_of_bathrooms])
  end

  def unit_params
    params[:unit] = params[:building][:units_attributes]['0']
    params.require(:unit).permit(:name, :square_feet, :number_of_bathrooms, :number_of_bedrooms)
  end

  def add_or_update_prices
    params[:price].each_pair do |key, value|
      existing_prices = Price.where(priceable_id: @building.id, priceable_type: 'Building', bed_type: key)
      if existing_prices.present?
        obj = existing_prices.first
        if value[:min_price].present?
          if obj.min_price.to_i != value[:min_price].to_i or obj.max_price.to_i != value[:max_price].to_i
            obj.update({ min_price: value[:min_price], max_price: value[:max_price] }) 
          end
        end
      else
        Price.create({priceable_id: @building.id, priceable_type: 'Building', min_price: value[:min_price], max_price: value[:max_price], bed_type: key}) if value[:min_price].present?
      end
    end
  end

end