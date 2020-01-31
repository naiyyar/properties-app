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
		FeaturedBuilding.renew_plan
	end
end