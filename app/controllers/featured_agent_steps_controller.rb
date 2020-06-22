class FeaturedAgentStepsController < ApplicationController
	include Wicked::Wizard
	steps :add_photos, :edit_photos, :payment

	def show
		@featured_agent = FeaturedAgent.find(params[:agent_id]) rescue nil
		case step
		when :add_photos
			@imageable = @featured_agent
		when :edit_photos
			@uploads 			= @featured_agent.uploads
			@photos_count = @uploads.count.to_i
		when :payment
			@featured_by       = 'manager'
			@price             = Billing::FEATURED_AGENT_PRICE
			@object_id         = @featured_agent.id
			@object_type       = 'FeaturedAgent'
			@saved_cards       = BillingService.new(current_user).get_saved_cards rescue nil
		end
		
		render_wizard
	end

	def update
		@featured_agent = FeaturedAgent.find(params[:id])
		@featured_agent.attributes = params[:uploads]
		render_wizard @featured_agent
	end
end
