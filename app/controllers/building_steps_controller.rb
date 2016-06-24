class BuildingStepsController < ApplicationController
	include Wicked::Wizard
	steps :building_information

	def show
		@building = Building.find(params[:building_id])
		render_wizard
	end

	def update
		@building = Building.find(params[:id])
		@building.attributes = params[:building]
		render_wizard @building
	end
end
