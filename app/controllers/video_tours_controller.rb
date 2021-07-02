class VideoToursController < ApplicationController
  load_and_authorize_resource except: [:index, :create, :new, :destroy]
  before_action :set_video_tour,  only: [:edit, :update, :destroy]
  before_action :find_tourable,   only: [:new, :show_tour]
  before_action :find_tours,      only: [:show_tour, :new]
  
  def index
    if params[:featured_listing_id].present?
      @featured_listing = FeaturedListing.find(params[:featured_listing_id])
      @video_tours = @featured_listing.video_tours
    else
      @category    = params[:category]
      @video_tours = VideoTour.where(id: params[:ids])
    end
  end

  def show_tour
    @tourable_type = params[:tourable_type]    
    @video_tours, @category = VideoTour.videos_by_categories(@video_tours)
    @categories = if @tourable_type == 'Building' 
                    VideoTour::CATEGORIES 
                  else 
                    [['Featured Listing', 'featured_listing']]
                  end

    respond_to do |format|
      format.html{
        redirect_back(fallback_location: building_path(@video_tours.values.first.first.tourable))
      }
      format.js
    end
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
        format.html { redirect_to request.referer }
        format.js
      else
        @errors = @video_tour.errors
        flash[:error] = @errors.messages
        format.js
      end
    end
  end

  # PATCH/PUT /video_tours/1
  # PATCH/PUT /video_tours/1.json
  def update
    respond_to do |format|
      if @video_tour.update(video_tour_params)
        format.html { redirect_to request.referer }
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

    def set_video_tour
      @video_tour = VideoTour.find(params[:id])
    end

    def find_tourable
      klass = params[:tourable_type].titleize || 'Building'
      @tourable = klass.constantize.find(params[:tourable_id])
    end
    
    def find_tours
      @video_tours = @tourable.video_tours rescue nil
    end

    def video_tour_params
      params.require(:video_tour).permit(:tourable_type, :tourable_id, :sort, :description, :category, :url, :image)
    end
end
