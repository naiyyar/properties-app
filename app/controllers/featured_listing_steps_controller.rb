class FeaturedListingStepsController < ApplicationController
	include Wicked::Wizard
	steps :add_amenities, :add_photos, :edit_photos, :payment

	def show
		@featured_listing = FeaturedListing.find_by(id: params[:featured_listing_id])
		case step
		when :add_amenitites

		when :add_photos
			@imageable = @featured_listing
		when :edit_photos
			@uploads 			= @featured_listing.uploads
			@photos_count = @featured_listing.uploads_count
		when :payment
			@featured_by       = 'manager'
			@price             = Billing::FEATURED_LISTING_PRICE
			@object_id         = @featured_listing.id
			@object_type       = 'FeaturedListing'
			@saved_cards       = BillingService.new(current_user).get_saved_cards rescue nil
		end
		
		render_wizard
	end

	def update
		@featured_listing = FeaturedListing.find(params[:id])
		@featured_listing.attributes = params[:uploads]
		render_wizard @featured_listing
	end
end