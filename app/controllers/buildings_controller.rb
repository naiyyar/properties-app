class BuildingsController < ApplicationController 
  load_and_authorize_resource # except: :favorite
  before_action :authenticate_user!, except: [:index, :show, :contribute, :create, :autocomplete, :apt_search, :favorite]
  before_action :find_building, only: [:show, :edit, :update, :destroy, :featured_by, :units, :favorite, :unfavorite]
  before_action :save_as_favourite, only: [:show]
  before_action :clear_cache, only: [:favorite, :unfavorite]

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

  def sitemap
    redirect_to "https://s3-us-west-2.amazonaws.com/#{ENV['AWS_S3_BUCKET']}/sitemaps/sitemap1.xml"
  end

  def favorite
    if current_user.present?
      current_user.favorite(@building)
      @saved_as_favourite = true
    else
      session[:favourite_object_id] = params[:object_id]
      @saved_as_favourite = false
    end
    respond_to do |format|
      format.js
      format.json{ render json: { success: true } }
    end
  end

  def unfavorite
    current_user.unfavorite(@building)
    render json: { message: 'Success' }
  end

  def units
    @units = @building.units
  end

  def featured_by
    @featured_comps = @building.featured_comps.order(created_at: :desc)
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
      @search_type = 'companies'
    else
      @buildings = Building.all
      @search_type = 'building'
    end
    @feature_comp_search_type = params[:featured_on].present? ? 'feature_comp_on' : 'feature_comp_as'
    @buildings = @buildings.text_search(params[:term]).reorder('building_street_address ASC').limit(10).includes(:units)
    @building = Building.where(id: params[:building_id]).first if params[:building_id].present?
    @search_bar_hidden = :hidden
  end

  def import
    Building.import_reviews(params[:file])
    redirect_to :back, notice: 'File imported.'
  end

  def show
    @show_map_btn = @half_footer = true
    @reviews = @building.building_reviews
    @distance_results = DistanceMatrix.get_data(@building) if Rails.env == 'production'
    broker_percent = BrokerFeePercent.first.percent_amount
    @saved_amounts = @building.saved_amount(RentMedian.all, broker_percent)
    @building_price = @building.price
    @rating_cache = @building.rating_cache?
    @price_ranges = {}
    prices = Price.where(range: @building_price)
    @building.bedroom_ranges.each do |bed_range|
      @price_ranges[bed_range] = prices.find_by(bed_type: bed_range)
    end
    #building + units images
    @uploads = @building.image_uploads
    @uploaded_images_count = @uploads.count
    @documents = @building.doc_uploads

    #Similiar buildings
    @similar_properties = Building.where(id: @building.active_comps.pluck(:building_id)).includes(:building_average) if @building.active_comps.present?
    
    @lat = @building.latitude
    @lng = @building.longitude

    buildings = @similar_properties.to_a + [@building]
    @gmaphash = Building.buildings_json_hash(buildings)

    @meta_desc = "#{@building.building_name if @building.building_name.present? } "+ 
                  "#{@building.building_street_address} is a #{@building.building_type if @building.building_type.present?} "+ 
                  "in #{@building.neighbohoods} #{@building.city} and is managed by #{@building.management_company.name if @building.management_company.present? }. "+ 
                  "Click to view #{@uploaded_images_count} photos and #{@building.reviews_count} reviews"
    
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
    
  end

  def update
    if @building.update(building_params)
      session[:after_contribute] = 'amenities' if params[:contribution].present?
      respond_to do |format|
        format.html {
          if params[:subaction].blank?
            redirect_to building_path(@building), notice: "Successfully Updated"
          else
            redirect_to building_path(@building)
          end
        }
        format.json {render json: @building}
      end
    else
      flash.now[:error] = "Error Updating"
      render :edit
    end
  end

  def destroy
    @building.destroy

    redirect_to buildings_path, notice: "Successfully Deleted"
  end

  private

  def find_building
    id = params[:object_id] || params[:id]
    @building = Building.find(id)
  end

  def building_params
    params.require(:building).permit!
  end

  def unit_params
    params[:unit] = params[:building][:units_attributes]['0']
    params.require(:unit).permit(:name, :square_feet, :number_of_bathrooms, :number_of_bedrooms)
  end

  def save_as_favourite
    if session[:favourite_object_id].present? and current_user.present?
      building = Building.find(session[:favourite_object_id])
      current_user.favorite(building)
      session[:favourite_object_id] = nil
    end
  end

  def clear_cache
    #Rails.cache.clear()
    @building.update(updated_at: Time.now)
  end

end