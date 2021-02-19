module LinksHelper
	def previous_link url
		site_link_h(text: '← Previous', 
								url: url, 
								klasses: "#{action_btn_classes} btn-o font-bold", 
								style: action_link_styles)
	end

	def next_link url
		site_link_h(text: next_text, 
								url: url, 
								klasses: "#{action_btn_classes} font-bold", 
								style: action_link_styles)
	end

	def done_link url
		site_link_h(text: 'Done', 
							  url: url, 
							  klasses: "#{action_btn_classes} btn-done font-bold",
							  style: action_link_styles)
	end

	def cancel_link url
		site_link_h(text: 'Cancel', url: url, klasses: "cancel #{btn_default_h} #{font_size16_h} font-bold")
	end

	def submit_link form, title:'Submit', disabled: false
		form.submit title, 
								class: 'btn btn-primary font-16 pl-28 pr-28 font-bold', 
								disabled: disabled, 
								style: action_link_styles
	end

	def next_text
		'Next →'
	end

	def neighborhood_link nb
		nb = 'Midtown' if nb == 'Midtown Manhattan'
		return '' if nb.blank?
    search_by_neighborhood_link(nb, 'MANHATTAN', false) 
	end

	def action_link_styles
		"width: #{browser.device.mobile? ? '8em' : '10em'};"
	end

	def action_links_alignment_class
		browser.device.mobile? ? 'text-center' : 'text-right'
	end

	def site_link_h text: '', url: '#', klasses: '', style: ''
		link_to text, url, class: klasses, style: style
	end

	def action_btn_classes
		"btn btn-primary #{font_size16_h} pl-28 pr-28"
	end

	def font_size16_h
		'font-16'
	end

	def btn_default_h
		'btn btn-default'
	end
end