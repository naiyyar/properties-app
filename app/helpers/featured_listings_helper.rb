module FeaturedListingsHelper

	def rent_with_currency object
		number_to_currency(object.rent, precision: 0)
	end

	def listing_address object
		"#{object.address} #{object.unit}, #{object.city}, NY, #{object.zipcode}"
	end

	def url_address listing
		"#{listing.address}-#{listing.unit}-#{listing.city}".parameterize
	end

	def date_available object
		object.date_available.present? ? object.date_available.strftime("%Y-%m-%d") : 'Now'
	end

	def next_prev_step_url object, step:
		edit_manager_featured_listing_user_path(current_user, 
                                            object_id: object.id,
                                            step: step,
                                            type: 'featured'
                                            )
	end

	def featured_listing_contact_owner_button object, size_class:
		link_to 'Contact Owner', 
						'javascript:;',
						onclick: "FEATURED_LISTING.showContactOwnerFormModal(#{object.id})", 
						class: "btn btn-primary #{size_class} font-14 font-bold", 
						remote: true
	end

end
