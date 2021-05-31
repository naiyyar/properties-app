module ReviewsHelper

	def reviewer_avatar review
		unless review.anonymous
      if review.user.avatar.present?
        avatar_image_tag(review.user.avatar.url)
      elsif review.user.image_url.present?
      	avatar_image_tag(review.user.image_url)
      else
      	content_tag 'div', review.user.user_name.split('')[0].capitalize, class: 'firstLetter'
      end
    else
    	avatar_image_tag('anonymous1.png')
    end
	end

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

	def years
		current_year = Date.today.year
		("2005".."#{current_year}").sort.reverse
	end

	def flag_review_link review
		if current_user.present?
			flag_as_inappropriate("#flagDescription#{review.id}", classes: flagged_classes(review))
  	else
  		flag_as_inappropriate("#signin")
    end
	end

	def flag_as_inappropriate href, classes: ''
		link_to flag_icon, href, 'data-bs-toggle' => 'modal', title: 'Flag as inappropriate', class: classes
	end

	def flagged_classes review
		review.marked_flag?(current_user) ? 'no-pointer flagged' : ''
	end

	def useful_review_link review
		if current_user.present?
			useful_link(review, href: 'javascript:;')
    else
    	useful_link(review, href: '#signin')
		end
	end

	def useful_link review, href: '#signin'
		link_to useful_title(review), 
					  href, 
					  class: "btn btn-o btn-blue btn-xs btn-round text-white #{useful_classes(review)}",
					  data: data_attributes(review)

	end

	def useful_title review
		"Useful (<span class='ur-count'>#{review.useful_reviews.count}</span>)".html_safe
	end

	def useful_classes review
		current_user ? "usefulButton #{review.marked_useful?(current_user) ? 'disabled' : ''}" : ''
	end

	def data_attributes review
		return { 'bs-toggle' => 'modal'} unless current_user
		{ reviewid: review.id, userid: current_user.id }
	end

	def write_review_link building
		link_to 'Write a Review', 
						new_building_review_path(building_id: building, contribution: 'building_review'), 
						class: 'btn btn-warning no-review btn-round txt-color-white'
	end

end
