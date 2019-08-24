module ListingsHelper
	def listing_header_title rentals
		if rentals == 'past'
			'<h4>Past Rental Listings</h4>'
		else
			"<h4 style='margin: 2px 0px;font-size: 14px;'> #{@building.building_name_or_address} </h2>" +
			"<p class='cardAddress text-muted font-sm'>#{@building.street_address} #{@building.zipcode}</p>" +
			"<b style='font-size: 14px;'>#{@listings.count} Active Rental Listings</b>"
		end
	end
end
