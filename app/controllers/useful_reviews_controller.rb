class UsefulReviewsController < ApplicationController
	
	def index
	end
	
	def new
	end

	def edit
	end

	def show
	end

	def create
		@useful_review = UsefulReview.new(useful_review_params)

    respond_to do |format|
      if @useful_review.save
        #format.js
        format.json { render :json => @useful_review }
      else
        #format.html { render :new }
        #format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
	end

	def update
	end

	def destroy
	end

	private
	def useful_review_params
    params.require(:useful_review).permit(:review_id, :user_id)
  end
end
