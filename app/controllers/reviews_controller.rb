class ReviewsController < ApplicationController 
  before_action :authenticate_user!, except: [:index, :show]


  def index
    @reviews = Review.all
  end

  def show
    @review = Review.find(params[:id])
  end

  def new
    @review = Review.new
  end

  def create
    @reviewable = find_reviewable
    @review = @reviewable.reviews.build(review_params)
    @review.user_id = current_user.id

    if @review.save
      flash[:notice] = "Review Created Successfully."
      redirect_to :back
    else
      flash.now[:error] = "Error Creating"
      render :new
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
    params.require(:review).permit(:building_review_title, :building_id, :user_id, :reviewable_id, :reviewable_type)
  end

  def find_reviewable
    params.each do |name, value|
      if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
      end
    end
  end

end