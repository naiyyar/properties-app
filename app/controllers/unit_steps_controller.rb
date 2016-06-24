class UnitStepsController < ApplicationController
	include Wicked::Wizard
	steps :unit_information

	def show
		@unit = Unit.find(params[:unit_id])
		render_wizard
	end

	def update
		@unit = unit.find(params[:id])
		@unit.attributes = params[:unit]
		render_wizard @unit
	end
end
