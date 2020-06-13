class FeaturedAgentStepsController < ApplicationController
	include Wicked::Wizard
	steps :add_photos, :edit_photos

	def show
		@featured_agent = FeaturedAgent.find(params[:agent_id])
		case step
		when :add_photos
			@imageable = @featured_agent
		when :edit_photos
			@uploads = @featured_agent.uploads
		end
		
		render_wizard
	end

	def update
		@featured_agent = FeaturedAgent.find(params[:id])
		@featured_agent.attributes = params[:uploads]
		render_wizard @featured_agent
	end
end
