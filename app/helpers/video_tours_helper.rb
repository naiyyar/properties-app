module VideoToursHelper
	def tour_link building_id, title = '3D / Video Tour'
		#link_to "<span class='fa fa-play'></span> #{title}".html_safe, 
		#				show_tour_path(building_id: @building.id), 
		#				remote: true, 
		#				class: 'btn btn-o btn-primary btn-sm btn-round font-bold'
		link_to "<span class='fa fa-play'></span> #{title}".html_safe, '#showTourModal', 
						'data-toggle' => 'modal', 
						class: 'btn btn-o btn-primary btn-sm btn-round font-bold',
						id: 'showTour'
	end

	def auto_play url
		matterport_url?(url) ? 'play=1' : 'rel=0&modestbranding=1&autohide=1&mute=1&showinfo=0&controls=0&autoplay=1'
	end

	def youtube_url? url
		url.include?('youtube') || url.match('youtube').present?
	end

	def matterport_url? url
		url.include?('matterport') || url.match('matterport').present?
	end

end
