class BuildingsController < ApplicationController 
  before_action :authenticate_user!, except: [:index, :show, :contribute,:create]

  def index
    @buildings = Building.order('created_at desc')
    respond_to do |format|
      format.html
      format.json { 
        render json: Building.search(params[:term])
      }
    end
  end

  def contribute
    respond_to do |format|
      format.html
      format.json { render json: @buildings = Building.search(params[:term]) }
    end
  end

  def show
    @building = Building.find(params[:id])
    @unit_review_count = 0
    @building.units.each do |unit|
      @unit_review_count = @unit_review_count + unit.reviews.count
    end
    @reviews = @building.reviews.order(created_at: :desc)
    @uploads = @building.uploads.order("created_at desc")
  end

  def new
    @building = Building.new
  end

  def create
    debugger
    @building = Building.create(building_params)

    if @building.savee
      flash[:notice] = "Building Created."
      redirect_to user_steps_path(building_id: @building.id, contribution_for: params[:contribution])
    else
      flash.now[:error] = "Error Creating"
      render :new
    end
  end

  def edit
    @building = Building.find(params[:id])
  end

  def update
    @building = Building.find(params[:id])

    if @building.update(building_params)
      redirect_to building_path(@building), notice: "Successfully Updated"
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
    params.require(:building).permit(:building_name, :building_street_address, :photo, :latitude, :longitude,:city,:state,:phone, :zipcode, :address2,:weburl,
                                      :pets_allowed,:laundry_facility,:parking,:doorman,:elevator,:description,
                                      uploads_attributes:[:id,:image,:imageable_id,:imageable_type])
  end

end