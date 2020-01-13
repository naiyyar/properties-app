namespace :featured_buildings do
	desc 'Making Expired featured buildings to inactive'
	task make_expired_to_inactive: :environment do
		FeaturedBuilding.by_manager.expired.update_all(active: false, renew: false)
	end
end
#'So on dev to test the expiration and renew charge,  the featuring could be set to 1 day (4 weeks on prod) 
#and renew charge 12 hours before feature expiration (2 days on prod) '
namespace :featured_plan do
	desc 'Renew plan 2 days before the end date.'
	task renew: :environment do
		FeaturedBuilding.where(renew: true).by_manager.not_expired.active.each do |featured_building|
			user = featured_building.user
			if featured_building.renew_plan?(ENV['SERVER_ROOT'])
				customer_id = user.stripe_customer_id
				if customer_id.present?
					@billing 	  = Billing.create(email: 							  user.email,
																			amount: 						  Billing::PRICE,
																			featured_building_id: featured_building.id,
																			user_id: 							user.id
																		)
					@billing.update_column(:stripe_customer_id, customer_id)
					card = BillingService.new.saved_cards(customer_id).last #cosidering last card default card
					@billing.create_charge_existing_card!(customer_id, card.id)
				end
			#elsif featured_building.send_renew_reminder?
				##'Renew plan reminder 2 days before the renew date.'
				#BillingMailer.send_renew_reminder(user.email, featured_building).deliver
			else
				#puts ENV['SERVER_ROOT']
			end
		end
	end
end