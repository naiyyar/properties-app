namespace :feature_plan do
	desc 'Renew plan 2 days before the end date.'
	task renew: :environment do
		FeaturedBuilding.where(renew: true).by_manager.not_expired.active.each do |featured_building|
			user = featured_building.user
			if featured_building.renew_plan?
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
			elsif featured_building.send_renew_reminder?
				##'Renew plan 2 days before the renew date.'
				BillingMailer.send_renew_reminder(user.email, featured_building).deliver
			end
		end
	end
end