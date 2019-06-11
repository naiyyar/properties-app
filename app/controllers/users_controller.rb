class UsersController < ApplicationController
	load_and_authorize_resource
	before_filter :set_user, only: [:edit, :update, :show, :contribution, :saved_buildings]

	def index
		@users = User.order('created_at desc').includes(:buildings)
	end

	def contribution
	end

	def saved_buildings
		@broker_percent = BrokerFeePercent.first.percent_amount
		favorable_ids = @user.favorites.pluck(:favorable_id)
		@buildings = Building.where(id: favorable_ids).paginate(:page => params[:page], :per_page => 20)
		@hash = Building.buildings_json_hash(@buildings)
    @zoom = 12
    @show_map_btn = true
	end

	def new
	end

	def show
		@buildings = @user.buildings.includes(:uploads, :building_average, :units).paginate(:page => params[:page], :per_page => 20)
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
		if current_user.present?
			@user = current_user
		else
			@user = User.find(params[:id])
		end
	end

	def user_params
		params.require(:user).permit(:name, :phone, :mobile, :about_me, :email, :avatar)
	end
end