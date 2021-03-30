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
			if upload.imageable_type == 'Building'
				upload.imageable.building_name
			elsif upload.imageable_type == 'Unit'
				upload.imageable.name
			else
				''
			end
		end
	end

	def reviewable_path review
		if review.reviewable_object.kind_of? Building
      building_path(review.reviewable_object)
    elsif review.reviewable_object.kind_of? Unit
      unit_path(review.reviewable_object)
    end
	end

	def single_image(building)
		building.uploads.present? ? building.uploads.last.image.url : 'no-photo-available.jpg'
	end

	def disabled(current_user, val)
		val.present? && current_user && !current_user.has_role?(:admin)
	end

	def contribute_left_side params
		'contributeLeftSide' if contribution?(params)
	end

	def contribute_wrapper params
		'contribute-wrapper' if contribution?(params)
	end

	def contribution? params
		action_name == 'contribute' || params[:contribution].present?
	end

	def recommended_percent object
		recommended = ''
		if object&.recommended_percent.present?
			rec_percent = object.recommended_percent
			recommended = if rec_percent.nan? 
											"#{thumbs_up_icon_helper} --%"
										elsif rec_percent == 0
											"#{thumbs_up_icon_helper} 0%"
										else
											"#{thumbs_up_icon_helper} #{rec_percent.to_i}%"
										end
		end
		"#{recommended} &nbsp;"
	end

	def heart_link object, user
		# To save as favourite sending js request
		# to unsave as favourite sending json request
		@current_user = current_user || user
		link_to heart_icon, saved_object_url(object), 
												remote: remote(object), class: fav_classes(object), 
												title: heart_link_title(object), 
												data: { objectid: object.id }, 
												method: :post
	end

	def fav_classes object
		"favourite save_link_#{object.id} #{saved_color_class(object)}"
	end

	def remote object
		(object.favorite_by?(@current_user) ? false : true)
	end

	def saved_object_url object
		object.favorite_by?(@current_user) ? 'javascript:;' : favorite_path(object_id: object.id)
	end

	def heart_link_title(object)
		(@current_user.present? && object.favorite_by?(@current_user)) ? 'Unsave' : 'Save'
	end

	def saved_color_class(object)
		(@current_user.present? && object.favorite_by?(@current_user)) ? 'filled-heart' : 'unfilled-heart'
	end

	def date_uploaded object
		"<b>#{ associated_object(object.imageable) }</b>" +
		"<p>Date uploaded: #{ object.created_at.strftime('%m/%d/%Y') }</p>" +
		"<p>" + fancybox_cta_buttons(object.imageable) + "</p>".html_safe # if @building.present?
	end

	def fancybox_cta_buttons imageable
		if imageable.class.name == 'FeaturedListing'
			featured_listing_contact_owner_button(imageable, size_class: 'txt-color-white btn-slider')
		else
			imageable && imageable.class.name == 'Building' ? show_slider_cta_links(imageable) : ''
		end
	end

	def show_slider_cta_links imageable
		CTALinksPolicy.new(imageable).show_contact_leasing? ? contact_leasing_link(imageable, '', 'btn-slider') : check_availability_link(imageable, 'btn-slider')
	end

	def sort_options
		@sort_options ||= [	['Recently Updated', '0'],
			['Least Expensive - Listing', '1'],
			['Most Expensive - Listing', '2'],
			['Least Expensive - Building', '3'],
			['Most Expensive - Building', '4']
		]
	end

	def sort_string
		['1','2','3','4'].include?(params[:sort_by]) ? sort_options[params[:sort_by].to_i][0] : 'Recently updated'
	end

	def feature_comp_bg_img_url uploads
		uploads.present? ? uploads.uploaded_img_url(:original) : image_url('no-photo.png')
	end

	def set_ranges building_price, price
		if building_price == 1
      "#{number_to_currency(price.max_price, precision: 0)} <"
    elsif building_price == 2 || building_price == 3
      "#{number_to_currency(price.min_price, precision: 0)} - #{number_to_currency(price.max_price, precision: 0)}"
    elsif building_price == 4
      "#{number_to_currency(price.min_price, precision: 0)} +"
    else
    	"#{number_to_currency(0, precision: 0)} - #{number_to_currency(0, precision: 0)}"
    end
	end

	def set_bed_ranges building, filters = nil
		if building.prices.present? || building.show_bed_ranges(filters).present?
	    (price_col(building, filters).to_s + types_col(building, filters).to_s).html_safe
	  end
	end

	def price_col b, filters
		if b.min_and_max_price? && show_price_range_with_filters?(b, filters)
			"<b> #{min_and_max_prices(b, filters)} </b>"
		elsif b.min_and_max_price? && b.min_listing_price > 0
			"<b> #{min_and_max_prices(b, filters)} </b>"
		else
			"<span> #{b.prices} </span>"
		end
	end

	def show_price_range_with_filters?(b, filters)
		filters.present? && b.min_listing_price > 0
	end

	def min_and_max_prices prop, filters
    if prop.min_and_max_price? && filters.blank?
  		return number_to_currency(prop.min_listing_price, precision: 0) if prop.min_listing_price == prop.max_listing_price
  		"#{number_to_currency(prop.min_listing_price, precision: 0)} - #{number_to_currency(prop.max_listing_price, precision: 0)}"
  	else
  		return number_to_currency(prop.min_price, precision: 0) if prop.min_price == prop.max_price
  		"#{number_to_currency(prop.min_price, precision: 0)} - #{number_to_currency(prop.max_price, precision: 0)}"
  	end
  end

  def types_col b, filters
		"<span> #{'|' if b.show_bed_ranges(filters).present?} #{b.show_bed_ranges(filters).join(', ')} </span>" +
		"#{with_bed_text(b, filters)}"
	end

	def with_bed_text b, filters
		return '' if b.has_only_studio?(filters) || b.has_only_room?(filters) || b.coliving?
		"#{'Bed' if b.bedroom_types? || (b.listings_count > 0)}"
	end

	def nearby_link_text nb
		case nb
		when 'Midtown'
			"Midtown NYC #{apt_rent_text}"
		when 'Corona'
			"Corona NY #{apt_rent_text}"
		when 'Flatiron Distric'
			"Flatiron #{apt_rent_text}"
		else
			"#{nb} #{apt_rent_text}"
		end
	end

	def apt_rent_text
		'Apartments For Rent'
	end
end
