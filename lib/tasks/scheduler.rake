#'So on dev to test the expiration and renew charge,  the featuring could be set to 1 day (4 weeks on prod) 
#and renew charge 12 hours before feature expiration (2 days on prod) '
namespace :featured_plan do
	desc 'Renew plan 2 days before the end date, Making Expired featured buildings to inactive'
	task renew_and_deactivate_featured_plan: :environment do
		FeaturedBuilding.renew_and_deactivate_featured_plan
		FeaturedAgent.renew_and_deactivate_featured_plan
	end
end