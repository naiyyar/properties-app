class UsersController < ApplicationController
	load_and_authorize_resource
	before_filter :set_user, only: [:edit, :update, :show, :contribution]

	def index
		@users = User.order('created_at desc').includes(:buildings)
	end

	def contribution
	end

	def new
	end

	def show
		@buildings = @user.buildings.paginate(:page => params[:page], :per_page => 20)
	end

	def edit
	end

	def create
	end

	def update
		if @user.update_attributes(user_params)
			redirect_to user_path(@user), notice: 'User updated successfully'
		else
			render :edit, error: 'Error in saving...'
		end
	end

	def destroy
	end


	private

	def set_user
		@user = User.find(params[:id])
	end

	def user_params
		params.require(:user).permit(:name, :phone, :mobile, :about_me, :email, :avatar)
	end
end