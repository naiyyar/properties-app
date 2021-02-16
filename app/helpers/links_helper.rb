module LinksHelper
	def previous_link url
		site_link_h(text: '<- Previous', url: url, klasses: "#{btn_primary_h} btn-o")
	end

	def next_link url
		site_link_h(text: next_text, url: url, klasses: btn_primary_h)
	end

	def done_link url
		site_link_h(text: 'Done', url: url, klasses: "#{btn_primary_h} btn-done")
	end

	def cancel_link url
		site_link_h(text: 'Cancel', url: url, klasses: "cancel #{btn_default_h} #{font_size16_h}")
	end

	def next_text
		'Next ->'
	end

	private

	def site_link_h text: '', url: '#', klasses: ''
		link_to text, url, class: klasses
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