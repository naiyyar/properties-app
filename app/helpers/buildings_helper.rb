module BuildingsHelper
	def rating_for_user(rateable_obj, rating_user, dimension = nil, options = {})
	   star = options[:star] || 5
	   readonly = false
	  if rating_user.present?
		  @object = rateable_obj
		  @user = rating_user
		  review_id = options[:review_id] || nil
		  @rating = Rate.find_by_rater_id_and_rateable_id_and_dimension_and_review_id(@user.id, @object.id, dimension,review_id)
		  stars = @rating ? @rating.stars : 0

		  disable_after_rate = options[:disable_after_rate] || false

		  if disable_after_rate
		    readonly = current_user.present? ? !rateable_obj.can_rate?(current_user, dimension) : true
		  end

		  content_tag :div, '', "data-dimension" => dimension, :class => "star", "data-rating" => stars,
		  "data-id" => rateable_obj.id, "data-classname" => rateable_obj.class.name,
		  "data-disable-after-rate" => disable_after_rate,
		  "data-readonly" => readonly,
		  "data-star-count" => star
		else
			content_tag :div, '', "data-dimension" => dimension, :class => "star", "data-rating" => 0,
		  "data-id" => rateable_obj.id, "data-classname" => rateable_obj.class.name,
		  "data-disable-after-rate" => disable_after_rate,
		  "data-readonly" => readonly,
		  "data-star-count" => star
		end
	end

	def imageable upload
		upload.imageable_type == 'Building' ? upload.imageable.building_name : upload.imageable.name
	end

	# def cross_street address
	# 	number = address.split(' ')[0]
	# 	ave_address = address.split(' ') - [number]
	# 	ave_address = ave_address.join(' ')
	# 	number_to_add = number.to_i / 10 #Removing Last digit
	# 	number_to_add = number_to_add / 2
		
	# 	case ave_address
	# 		when '1st Ave'
	# 			number_to_add + 3
	# 		when '2nd Ave'
	# 			number_to_add + 3
	# 		when '3rd Ave'
	# 			number_to_add + 10
	# 			when '4th ave'
	# 			number_to_add + 8
	# 		when '5th Ave'
	# 			if number.to_i <= 200
	# 				number_to_add + 13
	# 			elsif number.to_i <= 400
	# 				number_to_add + 16
	# 			elsif number.to_i <= 600
	# 				number_to_add + 18
	# 			elsif number.to_i <= 775
	# 				number_to_add + 20
	# 			elsif number.to_i >= 775 && number.to_i <= 1286
	# 				number - 18
	# 			else
	# 				''
	# 			end
	# 		else
	# 			''
	# 		end
	# end
end