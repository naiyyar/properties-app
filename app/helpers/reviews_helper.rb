module ReviewsHelper
	def link_to_building_show reviewable
		if reviewable.kind_of? Building
			name = reviewable.building_name.present? ? reviewable.building_name : reviewable.building_street_address
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

	def link_to_property_show reviewable
		if reviewable.kind_of? Building
			link_to_building_show(reviewable)
		elsif reviewable.kind_of? Unit
			link_to_unit_show(reviewable)
		end
	end

	def building_street_address reviewable
		if reviewable.present?
			if reviewable.kind_of? Building
				"#{reviewable.building_street_address }, #{city_state_zip(reviewable)}"
			else
				"#{reviewable.building.building_street_address}, #{city_state_zip(reviewable)}"
			end
		end
	end

	def city_state_zip reviewable
		if reviewable.kind_of? Building
			"#{reviewable.city}, #{reviewable.state} #{reviewable.zipcode}"
		else
			"#{reviewable.building.city}, #{reviewable.building.state} #{reviewable.building.zipcode}"
		end
	end

	def number_of_years
		['< 1 Year', '1-2 Years', '2-3 Years', '3-4 Years', '4-5 Years', '> 5 Years' ]
	end

	def years
		current_year = Date.today.year
		("2005".."#{current_year}").sort
	end
end
