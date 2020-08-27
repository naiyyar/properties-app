module VideoToursHelper
	def tour_link title = '3D / Video Tour'
		#link_to "<span class='fa fa-play'></span> #{title}".html_safe, '#showTourModal', 
		#				'data-toggle' => 'modal', 
		#				class: 'btn btn-o btn-primary btn-sm btn-round font-bold',
		#				id: 'showTour'
		link_to "<span class='fa fa-play'></span> #{title}".html_safe, '#video-tours', 
						class: 'btn btn-o btn-primary btn-sm btn-round font-bold', id: 'showTour'
	end

	def auto_play url
		if matterport_url?(url)
			'play=0'
		else
			'rel=0&modestbranding=1&autohide=1&mute=1&showinfo=0&controls=1&autoplay=1'
		end
	end

	def youtube_url? url
		url.include?('youtube') || url.match('youtube').present?
	end

	def matterport_url? url
		url.include?('matterport') || url.match('matterport').present?
	end

end
