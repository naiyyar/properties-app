module ReviewsHelper

	def avatar_image_tag url
		image_tag url, class: 'avatar', width: '40', height: '40'
	end

	def thumb_icons review
		if review.user_votes?
			span_tag(klasses: 'fa fa-thumbs-up recommended')
    else
      span_tag(klasses: 'fa fa-thumbs-down')
    end
	end

	def flag_as_inappropriate href, classes: ''
		link_to flag_icon, href, 'data-bs-toggle' => 'modal', title: 'Flag as inappropriate', class: classes
	end

	def flagged_classes review
		review.marked_flag?(current_user) ? 'no-pointer flagged' : ''
	end

	def write_review_link building
		link_to 'Write a Review', 
						new_building_review_path(building_id: building, contribution: 'building_review'), 
						class: 'btn btn-warning no-review btn-round txt-color-white'
	end

end
