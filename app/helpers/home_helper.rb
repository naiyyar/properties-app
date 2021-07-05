module HomeHelper

	def hero_image
    @mobile_view ? asset_path('hero-mobile.jpg') : asset_path('hero.jpg')
  end

	def spv_count_header_style
		if mobile? 
			'color: #0075c8; font-size: 21px;'
		else
			'color: #000; font-size: 21px;margin: 0px;'
		end
	end

	def marker_color price
		case price
		when 1 then '#fee5d9'
		when 2 then '#fcae91'
		when 3 then '#fb6a4a'
		when 4 then '#de2d26'
		else
			'#a50f15'
		end
	end

	def popular_search_url link_text
		"/nyc/#{link_text.downcase.split(' ').join('-')}"
	end

	def popular_search_link category, link_text
		link_to link_text, popular_search_url(link_text)
	end

end