class ReviewsController < ApplicationController 
  before_action :authenticate_user!, :except => [:new, :index, :create]


  def index
    @reviews = Review.all
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    if params['buildings-search-txt'].present?
      @reviewable = Building.find_by_building_street_address(params['buildings-search-txt'])
    else
      if params[:building_id]
        @reviewable = Building.find(params[:building_id])
      else
        @reviewable = Unit.find(params[:unit_id])
      end
    end
  end

  def create
    if current_user.nil?
      # Store the form data in the session so we can retrieve it after login
      session[:form_data] = params
      # Redirect the user to register/login
      redirect_to new_user_session_path
    else
      @reviewable = find_reviewable
      @review = @reviewable.reviews.build(review_params)
      @review.user_id = current_user.id

      if @review.save
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
        flash.now[:error] = "Error Creating"
        render :new
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
    @review.destroy

    redirect_to reviews_path, notice: "Successfully Deleted"
  end

  private

  def review_params
    params.require(:review).permit(:review_title, :building_id, :user_id, :reviewable_id, :reviewable_type,
                                    :pros, :cons, :other_advice, :tenant_status, :stay_time)
  end

  def find_reviewable
    params.each do |name, value|
      if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
      end
    end
  end

end