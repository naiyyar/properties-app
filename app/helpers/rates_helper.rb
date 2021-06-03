module RatesHelper
	def rating_for_user(rateable_obj, rating_user, dimension = nil, options = {})
	  star = options[:star] || 5
	   #readonly = true
	  if rating_user.present?
		  @object = rateable_obj
		  @user = rating_user
		  review_id = options[:review_id] || nil
		  @rating = @user.get_rating_by(rateable_obj.id, dimension, review_id)
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
end