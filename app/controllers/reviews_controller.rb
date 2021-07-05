class ReviewsController < ApplicationController 
  load_and_authorize_resource
  before_action :authenticate_user!,    :except => [:new, :index, :create]
  after_action :update_reviewable_info, only: :create

  include Filterrificable
  
  def index
    @reviews = filterrific_search_results.where(reviewable_type: 'Building').includes(:reviewable, :user)
    
    @pagy, @reviews = pagy(@reviews, items: 100)
    if params[:building_id].present?
      @reviews = @reviews.where(reviewable_id: params[:building_id])
    end
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    @uid = Time.now.to_i
    @reviewable = Building.find(params[:building_id])
    @search_bar_hidden = :hidden
  end

  def create
    if current_user.nil?
      # Store the form data in the session so we can retrieve it after login
      session[:form_data] = params
      # Redirect the user to register/login
      #redirect_to new_user_session_path
      redirect_to new_user_registration_path
    else
      @reviewable = find_reviewable
      if @reviewable.create_review(current_user, params, review_params)
        flash[:notice] = 'Review Created Successfully.'
        if @reviewable.kind_of? Unit
          redirect_to unit_path(@reviewable)
        else
          redirect_to building_path(@reviewable)
        end
      else
        flash.now[:error] = "Error in creating review. #{@review.errors.messages}"
        redirect_to request.referer
      end
    end
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    if @review.update(review_params)
      redirect_to review_path(@review), notice: 'Successfully Updated'
    else
      flash.now[:error] = 'Error Updating'
      render :edit
    end
  end

  def destroy
    @review = Review.find(params[:id])
    if @review.destroy
      respond_to do |format|
         format.html { redirect_to reviews_path, notice: 'Successfully Deleted' }
         format.js
      end
    end
    
  end

  private

  def review_params
    params.require(:review).permit!
  end

  def find_reviewable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
  end

  #updating recommended_percent and reviews_count
  def update_reviewable_info
    return unless @reviewable.kind_of?(Building)
    @reviewable.update(recommended_percent: @reviewable.suggested_percent, 
                       reviews_count: @reviewable.reviews.count)
  end

end