class UserStepsController < ApplicationController
	include Wicked::Wizard
	steps :next_page

	def show
		if params[:building_id]
			@building = @reviewable = @imageable = Building.find(params[:building_id])
		else
			@unit = @reviewable = @imageable = Unit.find(params[:unit_id])
		end
		render_wizard
	end

	# def update
	# 	# @building = Building.find(params[:id])
	# 	# @building.attributes = params[:building]
	# 	# render_wizard @building
	# end
end
