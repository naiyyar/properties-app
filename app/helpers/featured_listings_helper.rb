module FeaturedListingsHelper

	def listing_address object
		"#{object.address} Unit #{object.unit}, #{object.city}, NY, #{object.zipcode}"
	end

	def url_address listing
		"#{listing.address}-#{listing.unit}-#{listing.city}".parameterize
	end

	def date_available object
		object.date_available.present? ? object.date_available.strftime("%Y-%m-%d") : nil
	end

	def next_prev_step_url object, step:
		edit_manager_featured_listing_user_path(current_user, 
                                            object_id: object.id,
                                            step: step,
                                            type: 'featured'
                                            )
	end
end
