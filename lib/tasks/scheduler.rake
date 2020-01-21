namespace :featured_buildings do
	desc 'Making Expired featured buildings to inactive'
	task set_expired_to_inactive: :environment do
		FeaturedBuilding.set_expired_plans_to_inactive
		FeaturedBuilding.set_expired_plans_to_inactive_if_autorenew_is_off
	end
end
#'So on dev to test the expiration and renew charge,  the featuring could be set to 1 day (4 weeks on prod) 
#and renew charge 12 hours before feature expiration (2 days on prod) '
namespace :featured_plan do
	desc 'Renew plan 2 days before the end date.'
	task renew: :environment do
		FeaturedBuilding.where(renew: true).by_manager.not_expired.active.each do |featured_building|
			user 			 = featured_building.user
			user_email = user.email
			if featured_building.renew_plan?(ENV['SERVER_ROOT'])
				customer_id = user.stripe_customer_id
				if customer_id.present?
					card = BillingService.new.saved_cards(customer_id).last #cosidering last card default card
					if card.present?
						@billing 	= Billing.new({ email: 								user_email,
																			amount: 						  Billing::PRICE,
																			featured_building_id: featured_building.id,
																			user_id: 							user.id,
																			renew_date:           Time.now,
																			billing_card_id:      card.id,
																			brand: 								card.brand
																		})
						unless @billing.save_and_charge_existing_card!(customer_id: customer_id, card_id: card.id)
							@billing.status = 'Failed'
							@billing.save
							BillingMailer.payment_failed(user_email).deliver
						end
					else
						BillingMailer.no_card_payment_failed(user_email).deliver
					end
				else
					BillingMailer.no_card_payment_failed(user_email).deliver
				end
			end
		end
	end
end