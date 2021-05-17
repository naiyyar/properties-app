module IconsHelper
	def featured_badge_helper
	  content_tag 'div', '', class: 'comp featured round' do
	  	span_tag(klasses: 'fa fa-certificate font-14')
	  end
	end

	def flag_icon
		span_tag(klasses: 'fa fa-flag-o font-16')
	end

	def tour_icon_helper
	  content_tag 'div', '', class: 'video-tour-icon' do
	  	span_tag(klasses: 'fa fa-video-camera')
	  end
	end

	def plus_icon
		span_tag(klasses: 'fa fa-plus')
	end

	def icon_search_helper other_class: ''
		content_tag 'div', '', class: "icon-search-shared #{other_class}" do
			span_tag(klasses: 'fa fa-search')
	  end
	end

	def heart_icon
		span_tag(klasses: 'fa fa-heart')
	end

	def map_marker_icon_helper
		span_tag(klasses: 'fa fa-map-marker')
	end

	def thumbs_up_icon_helper
		thumb_icon_helper('fa-thumbs-up recommended')
	end

	def thumbs_down_icon_helper
		thumb_icon_helper('fa-thumbs-down')
	end

	def trash_icon_helper
		span_tag(klasses: 'fa fa-trash')
	end

	def edit_icon_helper
		span_tag(klasses: 'fa fa-edit')
	end

	def repeat_icon_helper
		span_tag(klasses: 'fa fa-repeat')
	end

	def globe_icon_helper
		span_tag(klasses: 'fa fa-globe')
	end
	
	def thumb_icon_helper klass
		span_tag(klasses: "fa #{klass}")
	end
	
	def span_tag klasses: ''
		content_tag 'span', '', class: "#{klasses}"
	end

end