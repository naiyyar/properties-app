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

	def building_name_or_address building
		building.building_name.present? ? building.building_name : building.building_street_address
	end

	def single_image(building)
		building.uploads.present? ? building.uploads.last.image.url : 'no-photo-available.jpg'
	end

	def contribution? params
		action_name == 'contribute' || params[:contribution].present?
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

	def listing_amenities
		@listing_amenities ||= {
			months_free_rent: 'Months Free Rent',
			owner_paid: 			'Owner Paid',
			rent_stabilized: 	'Rent Stabilized'
		}
	end

	def recommended_percent object
		thumb_icon = "| <span class='fa fa-thumbs-up recommended'></span>"
		recommended = ''
		if object.present? && object.recommended_percent.present?
			rec_percent = object.recommended_percent
			if rec_percent.nan? 
				recommended = "#{thumb_icon} --%"
			elsif rec_percent == 0
				recommended = "#{thumb_icon} 0%"
			else
				recommended = "#{thumb_icon} #{rec_percent.to_i}%"
			end
		end
		"#{recommended} &nbsp;"
	end

	def heart_icon
		'<span class="fa fa-heart"></span>'.html_safe
	end

	def heart_link object, user
		# To save as favourite sending js request
		# to unsave as favourite sending json request
		@current_user = current_user.present? ? current_user : user
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

	def check_availability_link building, sl_class=nil
		if building.active_web_url?
			bt_block_class = sl_class.present? ? sl_class : 'btn-block'
      link_to 'Check Availability', building.web_url, 
      														onclick: "window.open(this.href,'_blank');return false;",
      														class: "btn #{bt_block_class} btn-primary txt-color-white font-bolder btn-round",
      														style: "padding: #{bt_block_class.include?('btn-xs') ? '8px 0px' : ''}"
    else
      link_to check_availability, building_url(building), class: 'btn btn-block btn-primary invisible'
    end
	end

	def check_availability_button web_url, klass
		link_to 'Check Availability', web_url, 
																	onclick: "window.open(this.href,'_blank');return false;",
																	class: "btn btn-primary #{klass} btn-round ca"
	end

	def contact_leasing_button building, event, klass
		link_to 'Contact Leasing', 'javascript:;', 
																onclick: "showLeasingContactPopup(#{building.id})", 
																 class: "btn btn-primary #{klass} btn-round"
	end

	def active_listings_button building, event, klass, listings_count
		link_to "#{listings_count} Active Listings" , 'javascript:;', 
																									onclick: "showActiveListingsPopup(#{building.id})", 
																									class: "btn btn-primary active-listing-link #{klass} btn-round"
	end

	def apply_online_link building
		link_to 'Apply Online', building.online_application_link, 
														class: 'btn btn-primary btn-o btn-block font-bolder btn-round', 
														target: '_blank'
	end

	def contact_leasing_link building, bg_col='', sl_class=''
		bt_block_class = sl_class.present? ? sl_class : 'btn-block'
		link_to 'Contact Leasing Team', new_contact_path(building_id: building.id), 
																		class: "btn btn-primary #{bg_col} #{bt_block_class} txt-color-white font-bolder btn-round sh-contact-leasing", 
																		remote: true
	end

	def check_availability
		'<b>Check Availability</b>'.html_safe
	end

	def date_uploaded object
		"<b>#{ associated_object(object.imageable) }</b>" +
		"<p>Date uploaded: #{ object.created_at.strftime('%m/%d/%Y') }</p>" +
		"<p>" + fancybox_cta_buttons + "</p>".html_safe if @building.present?
	end

	def fancybox_cta_buttons
		@building.show_contact_leasing? ? contact_leasing_link(@building, '', 'btn-slider') : check_availability_link(@building, 'btn-slider')
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
		uploads.present? ? uploads.uploaded_img_url : image_url('no-photo.png')
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
		if b.min_and_max_price? && b.act_listings.sum(:rent) > 0
			"<b> #{min_and_max_prices(b, filters)} </b>"
		else
			"<span> #{b.prices} </span>"
		end
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
		"#{'Bed' if b.bedroom_types? && (!b.has_only_studio?(filters) && !b.has_only_room?(filters))}" # #{',' if b.bedroom_types? && b.coliving_with_building_beds?}" # #{'CoLiving' if b.coliving_with_building_beds? }
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
