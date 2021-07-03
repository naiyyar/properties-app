module VideoToursHelper
	
	def launch_tour_link tourable
		link_to tour_link_title(tourable), 
						show_tour_path(tourable_id: tourable.id, tourable_type: tourable.class.name),
						class: 'btn btn-o btn-primary btn-sm btn-round font-bold btn-block font-14', 
						remote: true
	end

	def tour_link_title tourable
		"<span class='fa fa-play'></span> Launch 3D / Video Tours".html_safe
	end

	def show_tour_icon? object
		['Building', 'FeaturedListing'].include?(object.class.name)
	end

	def formated_url url
		encoded_url = URI.encode(url)
		uri 				= URI.parse(encoded_url)
		query_str 	= uri.query
		new_url 		= if query_str.present?
										uri.to_s.gsub(query_str, new_query_string(query_str, url))
									else
										"#{url}?#{auto_play(url)}"
									end
		return new_url
	end

	def new_query_string str, url
		"#{str}&#{auto_play(url)}"
	end

	def auto_play url
		if matterport_url?(url)
			'play=0'
		else
			'rel=0&modestbranding=1&autohide=1&mute=1&showinfo=0&controls=1&autoplay=0'
		end
	end

	# def youtube_url? url
	# 	url.include?('youtube') || url.match('youtube').present?
	# end

	def matterport_url? url
		url.include?('matterport') || url.match('matterport').present?
	end

end
