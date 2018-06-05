class ReviewsController < ApplicationController 
  load_and_authorize_resource
  before_action :authenticate_user!, :except => [:new, :index, :create]

  # def index
  #   if params[:building_id].present?
  #     @reviewable = Building.find(params[:building_id])
  #   elsif params[:unit_id].present?
  #     @reviewable = Unit.find(params[:unit_id])
  #   else
  #     @reviews = Review.order('created_at desc')
  #   end
  #   @reviews = @reviewable.reviews.order('created_at desc') if @reviewable.present?
  # end
  
  #from production
  def index
    if params[:building_id].present?
      @reviews = Review.where(reviewable_id: params[:building_id]).order('created_at desc')
    elsif params[:unit_id].present?
      @reviews = Review.where(reviewable_id: params[:unit_id]).order('created_at desc')
    else
      @reviews = Review.order('created_at desc').includes(:reviewable, :user)
    end
  end

  def destroy_scraped_reviews
    Review.where(scraped: true).destroy_all
    redirect_to :back, notice: 'Destroyed successfully'
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    Upload.where(imageable_id: nil, imageable_type: ['',nil]).destroy_all
    if params['buildings-search-txt'].present?
      address = params['buildings-search-txt'].split(',')[0]
      @reviewable = Building.find_by_building_street_address_and_zipcode(address, params[:zip])
      if @reviewable.blank?
        @reviewable = Building.find_by_building_street_address(address)
      end
    else
      if params[:building_id]
        @reviewable = Building.find(params[:building_id])
      else
        @reviewable = Unit.find(params[:unit_id])
      end
    end
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
      @review = @reviewable.reviews.build(review_params)
      @review.user_id = current_user.id
      if @review.save
        #@review.save_images(params[:review_attachments]) if params[:review_attachments].present?
        @review.set_imageable(params[:upload_uid])
        session[:after_contribute] = 'reviews' if params[:contribution].present?
        if params[:score].present? 
          params[:score].keys.each do |dimension|
            # params[dimension] => score
            current_user.create_rating(params[:score][dimension], @reviewable, @review.id, dimension) #if params[:score].present?
          end
        end
        
        if params[:vote] == 'true'
          vote = current_user.vote_for(@reviewable)
        else
          vote = current_user.vote_against(@reviewable)
        end
        if vote.present?
          vote.review_id = @review.id
          vote.save
        end
        flash[:notice] = "Review Created Successfully."
        if @reviewable.kind_of? Unit
           redirect_to unit_path(@reviewable)
        else
          redirect_to building_path(@reviewable)
        end
      else
        # @review.errors.messages[:tos_agreement].first
        flash.now[:error] = "Error in creating review. #{@review.errors.messages[:tos_agreement].first}"
        redirect_to :back
      end
    end
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update

    @review = Review.find(params[:id])

    if @review.update(review_params)
      redirect_to review_path(@review), notice: "Successfully Updated"
    else
      flash.now[:error] = "Error Updating"
      render :edit
    end
  end

  def destroy
    @review = Review.find(params[:id])
    if @review.destroy
      respond_to do |format|
         format.html { redirect_to reviews_path, notice: "Successfully Deleted" }
         format.js
      end
    end
    
  end

  private

  def review_params
    params.require(:review).permit!
    #(:review_title, :building_id, :user_id, :reviewable_id, :reviewable_type,:pros, :cons, :other_advice, :tenant_status, :stay_time, :anonymous, :tos_agreement, :last_year_at_residence, :scraped)
  end

  def find_reviewable
    params.each do |name, value|
      if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
      end
    end
  end

end