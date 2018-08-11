module BuildingsHelper
	def rating_for_user(rateable_obj, rating_user, dimension = nil, options = {})
	  star = options[:star] || 5
	   #readonly = true
	  if rating_user.present?
		  @object = rateable_obj
		  @user = rating_user
		  review_id = options[:review_id] || nil
		  @rating = Rate.find_by_rater_id_and_rateable_id_and_dimension_and_review_id(@user.id, @object.id, dimension,review_id)
		  stars = @rating ? @rating.stars : 0

		  disable_after_rate = options[:disable_after_rate] || false
		  target       = options[:target]       || ''
	    targetText   = options[:targetText]   || ''
	    targetType   = options[:targetType]   || 'hint'
	    targetFormat = options[:targetFormat] || '{score}'
	    targetScore  = options[:targetScore]  || ''

		  if disable_after_rate
		    readonly = rating_user.present? ? !rateable_obj.can_rate?(rating_user, dimension) : true
		  end

		  content_tag :div, '', "data-dimension" => dimension, :class => "star", "data-rating" => stars,
		  "data-id" => rateable_obj.id, "data-classname" => rateable_obj.class.name,
		  "data-disable-after-rate" => disable_after_rate,
		  "data-readonly" => readonly,
		  "data-star-count" => star,
      "data-target" => target,
      "data-target-text" => targetText,
      "data-target-format" => targetFormat,
      "data-target-score" => targetScore
		else
			content_tag :div, '', "data-dimension" => dimension, :class => "star", "data-rating" => 0,
		  "data-id" => rateable_obj.id, "data-classname" => rateable_obj.class.name,
		  "data-disable-after-rate" => disable_after_rate,
		  "data-readonly" => readonly,
		  "data-star-count" => star
		end
	end

	def imageable upload
		if upload.imageable.present?
			upload.imageable_type == 'Building' ? upload.imageable.building_name : upload.imageable.name
		end
	end

	def reviewable_path review
		 if review.reviewable_object.kind_of? Building
      building_path(review.reviewable_object)
    elsif review.reviewable_object.kind_of? Unit
      unit_path(review.reviewable_object)
    end
	end

	def building_name_or_address building
		building.building_name.present? ? building.building_name : building.building_street_address
	end

	def single_image(building)
		building.uploads.present? ? building.uploads.last.image.url : 'no-photo-available.jpg'
	end

	def contribution? params
		params[:action] == 'contribute' || params[:contribution].present?
	end

	def disabled(current_user, val)
		if val.present? && current_user && !current_user.has_role?(:admin)
			true
		end
	end

	def contribute_left_side params
		if contribution?(params)
			'contributeLeftSide'
		end
	end

	def contribute_wrapper params
		if contribution?(params)
			'contribute-wrapper'
		end
	end

	def building_amenities
		{
			no_fee: 'No Fee Building',
			courtyard: 'Courtyard',
			pets_allowed_cats: 'Cats Allowed',
			pets_allowed_dogs: 'Dogs Allowed',
			doorman: 'Doorman',
			elevator: 'Elevator',
			garage: 'Garage',
			gym: 'Gym',
			laundry_facility: 'Laundry in Building',
			live_in_super: 'Live in super',
			management_company_run: 'Management Company Run',
			parking: 'Parking',
			roof_deck: 'Roof Deck',
			swimming_pool: 'Swimming Pool',
			walk_up: 'Walk up',
			childrens_playroom: 'Childrens Playroom',
		}
	end

	def recommended_percent building
		thumb_icon = "| <span class='fa fa-thumbs-up recommended'></span>"
		if building.present?
			if building.recommended_percent.nan? 
				"#{thumb_icon} --%"
			elsif building.recommended_percent == 0
				"#{thumb_icon} 0%"
			else
				"#{thumb_icon} #{building.recommended_percent.to_i}%  &nbsp; | Reviews: #{building.reviews.count}"
			end
		end
	end

end