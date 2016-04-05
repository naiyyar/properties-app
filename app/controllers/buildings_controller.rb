class BuildingsController < ApplicationController 
  before_action :authenticate_user!, except: [:index, :show]


  def index
    @buildings = Building.search(params[:search])
  end

  def show
    @building = Building.find(params[:id])
    @review = Review.new
    @reviews = @building.reviews.order(created_at: :desc)
  end

  def new
    @building = Building.new
  end

  def create
    @building = Building.create(building_params)

    if @building.save
      flash[:notice] = "Building Created"
      redirect_to building_path(@building)
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
    params.require(:building).permit(:building_name, :building_street_address, :photo, :latitude, :longitude)
  end

end