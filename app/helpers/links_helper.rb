module LinksHelper
	def previous_link url
		site_link_h(text: '← Previous', 
								url: url, 
								klasses: "#{btn_primary_h} btn-o font-bold", 
								style: next_prev_link_style_h)
	end

	def next_link url
		site_link_h(text: next_text, 
								url: url, 
								klasses: "#{btn_primary_h} font-bold", 
								style: next_prev_link_style_h)
	end

	def done_link url
		site_link_h(text: 'Done', url: url, klasses: "#{btn_primary_h} btn-done font-bold")
	end

	def cancel_link url
		site_link_h(text: 'Cancel', url: url, klasses: "cancel #{btn_default_h} #{font_size16_h} font-bold")
	end

	def next_text
		'Next →'
	end

	def neighborhood_link nb
		nb = 'Midtown' if nb == 'Midtown Manhattan'
		return '' if nb.blank?
    search_by_neighborhood_link(nb, 'MANHATTAN', false) 
	end

	def next_prev_link_style_h
		'width: 10em;'
	end

	private

	def site_link_h text: '', url: '#', klasses: '', style: ''
		link_to text, url, class: klasses, style: style
	end

	def btn_primary_h
		"btn btn-primary #{font_size16_h} pl-28 pr-28"
	end

	def font_size16_h
		'font-16'
	end

	def btn_default_h
		'btn btn-default'
	end
end