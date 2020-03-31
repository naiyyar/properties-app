module ListingsHelper
	def listing_header_title rentals
		"<h4 #{name_styles}> #{@building.building_name_or_address} </h2>" +
		"<p class='cardAddress text-muted address_font'>#{@building.street_address} #{@building.zipcode}</p>" +
		"<p style='font-size: 14px;margin-bottom: 6px;'>#{@listings.size} #{type_text(rentals)}</p>"
	end

	def type_text type
		type == 'past' ? 'Past Rental Listings' : 'Active Rental Listings'
	end

	def name_styles
		"style='margin: 2px 0px; font-size: #{name_text_font};font-weight: bolder;'"
	end

	def name_text_font
		browser.device.mobile? ? '14px;' : '16px;'
	end
end
