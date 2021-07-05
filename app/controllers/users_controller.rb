class UsersController < ApplicationController
	load_and_authorize_resource :find_by => :slug 
	before_action :authenticate_user!, only: [:show, :edit, :saved_buildings]
	before_action :set_user, except: [:index, :create]

	def index
		@all_users = User.order(created_at: :desc)
		@pagy, @users = pagy(@all_users.includes(:buildings, :favorites), items: 100)
	end

	def contribution
	end

	def new
	end

	def show
		
	end

	def edit
		@pagy, @buildings = pagy(@user.buildings.includes(:uploads))
	end

	def create
	end

	def update
		if @user.update_attributes(user_params)
			redirect_to edit_user_path(@user), notice: 'User updated successfully'
		else
			flash[:error] = @user.errors.messages.values[0][0]
			redirect_back(fallback_location: user_path(@user))
		end
	end

	def destroy
	end


	private

	def set_user
		@user = current_user || User.friendly.find(params[:id])
	end

	def user_params
		params.require(:user).permit(:name, :phone, :mobile, :about_me, :email, :avatar)
	end
	
end