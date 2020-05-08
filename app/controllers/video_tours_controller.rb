class VideoToursController < ApplicationController
  before_action :set_video_tour, only: [:show, :edit, :update, :destroy]
  before_action :find_builidng, only: [:index, :new, :show_tour]
  before_action :find_tours, only: [:index, :show_tour, :new]
  # GET /video_tours
  # GET /video_tours.json
  def index
    
  end

  # GET /video_tours/1
  # GET /video_tours/1.json
  def show
  end

  def show_tour
    @video_tours = @video_tours.group_by{|v| v.category}
  end

  # GET /video_tours/new
  def new
    @category   = params[:category]
    @sort_index = params[:sort_index].to_i if params[:sort_index].present?
    @video_tour = VideoTour.new
  end

  # GET /video_tours/1/edit
  def edit
  end

  # POST /video_tours
  # POST /video_tours.json
  def create
    @video_tour = VideoTour.new(video_tour_params)

    respond_to do |format|
      if @video_tour.save
        @category = @video_tour.category
        format.html
        format.js
      else
        @errors = @video_tour.errors
        format.js
      end
    end
  end

  # PATCH/PUT /video_tours/1
  # PATCH/PUT /video_tours/1.json
  def update
    respond_to do |format|
      if @video_tour.update(video_tour_params)
        format.js
      else
        format.html { render :edit }
        format.json { render json: @video_tour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /video_tours/1
  # DELETE /video_tours/1.json
  def destroy
    @video_tour.destroy
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video_tour
      @video_tour = VideoTour.find(params[:id])
    end

    def find_builidng
      @building = Building.find(params[:building_id])
    end
    
    def find_tours
      @video_tours = @building.video_tours rescue nil
    end

    def video_tour_params
      params.require(:video_tour).permit(:building_id, :sort, :description, :category, :url)
    end
end
