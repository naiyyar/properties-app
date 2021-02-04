module FeaturedListingsHelper

	def next_prev_step_url object, step:
		edit_manager_featured_listing_user_path(current_user, 
                                            object_id: object.id,
                                            step: step,
                                            type: 'featured'
                                            )
	end
end
