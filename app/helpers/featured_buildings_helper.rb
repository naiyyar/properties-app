module FeaturedBuildingsHelper

	def start_date fb
		Time.zone.parse(fb.try(:start_date).to_s)&.strftime('%Y-%m-%d %H:%M')
	end

	def end_date fb
		Time.zone.parse(fb.try(:end_date).to_s)&.strftime('%Y-%m-%d %H:%M')
	end

	def new_featured_building_link
		link_to 'Add New Featured Building', 
						new_manager_featured_building_user_path(current_user, type: 'featured'), 
						class: 'btn btn-primary'
	end
end
