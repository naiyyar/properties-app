class UnitsController < ApplicationController
  load_and_authorize_resource
  before_action :set_unit, only: [:show, :edit, :update, :destroy]

  # GET /units
  # GET /units.json
  def index
    @filterrific = initialize_filterrific(
      Unit,
      params[:filterrific],
      available_filters: [:search_query]
    ) or return
    @units = @filterrific.find.reorder('created_at desc').includes(:building).paginate(:page => params[:page], :per_page => 100)

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /units/1
  # GET /units/1.json
  def show
    @show_map_btn = true
    @unit_uploads = @unit.uploads.order("created_at desc")
    @lat = @unit.building.latitude
    @lng = @unit.building.longitude
    @gmaphash = [
                  {
                    title: @unit.name,
                    image: Upload.marker_image(@unit),
                    address: @unit.building.street_address,
                    position: {
                      lat: @unit.building.latitude,
                      lng: @unit.building.longitude
                    },
                    markerIcon: ActionController::Base.helpers.asset_path("marker-blue.png")

                  }
                ]
    # @hash = Gmaps4rails.build_markers(@unit.building) do |building, marker|
    #   marker.lat building.latitude
    #   marker.lng building.longitude
    #   building_link = view_context.link_to building.building_name, building_path(building)
    #   marker.title "#{@unit.name}-#{building.building_name}"
    #   marker.infowindow render_to_string(:partial => '/layouts/shared/custom_infowindow', 
    #                                      :locals => { 
    #                                                   building_link: building_link, 
    #                                                   building: building,
    #                                                   image: Upload.marker_image(@unit)
    #                                                 }
    #                                      )
    #   #To add own marker
    #   marker.picture ({
    #         'url' => ActionController::Base.helpers.asset_path('marker-blue.png'),
    #         'width' => 50,
    #         'height' => 50
    #       })
    # end
    flash[:notice] = "Photos Uploaded Successfully." if params[:from_uploaded].present?
  end

  def units_search
    @units = Unit.where(building_id: params[:building_id]).search(params[:term])
  end

  # GET /units/new
  def new
    @unit = Unit.new
  end

  # GET /units/1/edit
  def edit
    @search_bar_hidden = :hidden
  end

  # POST /units
  # POST /units.json
  def create
    @unit = Unit.new(unit_params)

    respond_to do |format|
      if @unit.save
        format.html { redirect_to unit_steps_path(unit_id: @unit.id), notice: 'Unit was successfully created.' }
        format.json { render :show, status: :created, location: @unit }
      else
        format.html { render :new }
        format.json { render json: @unit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /units/1
  # PATCH/PUT /units/1.json
  def update
    @unit.update(unit_params)
    session[:after_contribute] = params[:contribution] if params[:contribution].present?

    redirect_to unit_path(@unit), notice: 'Unit was successfully updated.'
  end

  # DELETE /units/1
  # DELETE /units/1.json
  def destroy
    @unit.destroy
    respond_to do |format|
      format.html { redirect_to units_url, notice: 'Unit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_unit
      @unit = Unit.find(params[:id])
      @unit = Unit.find(params[:unit_id]) if @unit.blank? and params[:unit_id].present?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def unit_params
      params.require(:unit).permit(:building_id,:name,:description,:pros,:cons,:number_of_bedrooms,
                                   :number_of_bathrooms,:monthly_rent,:square_feet,:total_upfront_cost,
                                   :rent_start_date,:rent_end_date,:security_deposit,:broker_fee,
                                   :move_in_fee,:rent_upfront_cost,:processing_fee,:balcony,:board_approval_required,
                                   :converted_unit,:dishwasher,:fireplace,:furnished,:guarantors_accepted,
                                   :loft,:rent_controlled,:private_landlord,:storage_available,
                                   :sublet,:terrace,:can_be_converted,:dryer_in_unit
                                   )
    end
end
