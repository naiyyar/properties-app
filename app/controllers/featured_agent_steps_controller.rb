class FeaturedAgentStepsController < ApplicationController
	include Wicked::Wizard
	steps :add_photos, :edit_photos, :payment

	def show
		@featured_agent = FeaturedAgent.find(params[:agent_id]) rescue nil
		case step
		when :add_photos
			@imageable = @featured_agent
			@uploads 	 = @featured_agent.uploads
		when :edit_photos
			@uploads 			= @featured_agent.uploads
			@photos_count = @uploads.count.to_i
		when :payment
			@object 		 = @featured_agent
			@featured_by = 'manager'
			@object_id   = @featured_agent.id
			@object_type = 'FeaturedAgent'
			@price       = Billing::FEATURED_PRICES[@object_type]
			@saved_cards = BillingService.new(current_user).get_saved_cards rescue nil
		end
		
		render_wizard
	end

	def update
		@featured_agent = FeaturedAgent.find(params[:id])
		@featured_agent.attributes = params[:uploads]
		render_wizard @featured_agent
	end
end
