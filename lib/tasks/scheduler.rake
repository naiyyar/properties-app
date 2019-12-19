namespace :featured_buildings do
	desc 'Making Expired featured buildings to inactive'
	task make_expired_to_inactive: :environment do
		FeaturedBuilding.by_manager.expired.update_all(active: false)
	end
end