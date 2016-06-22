module ReviewsHelper
	def link_to_building_show reviewable
		if reviewable.kind_of? Building
			name = reviewable.building_name
			path = building_path(reviewable)
		else
			name = reviewable.building.building_name
			path = building_path(reviewable.building)
		end
		return link_to "#{name}", "#{path}"
	end

	def link_to_unit_show reviewable
		return link_to "#{reviewable.name}", "#{unit_path(reviewable)}"
	end

	def building_street_address reviewable
		if reviewable.kind_of? Building
			reviewable.building_street_address 
		else
			reviewable.building.building_street_address
		end
	end

	def city_state_zip reviewable
		if reviewable.kind_of? Building
			"#{reviewable.city}, #{reviewable.state} #{reviewable.zipcode}"
		else
			"#{reviewable.building.city}, #{reviewable.building.state} #{reviewable.building.zipcode}"
		end
	end
end
