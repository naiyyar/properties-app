module ListingsHelper
	def listing_header_title rentals
		if rentals == 'past'
			'<h4>Past Rental Listings</h4>'
		else
			"<h3 style='margin-top: 0px;'> #{@building.building_name_or_address} </h2>" +
			"<h4 class='cardAddress text-muted font-sm'>#{@building.street_address}</h4>" +
			"<h4>#{@listings.count} Active Rental Listings</h4>"
		end
	end
end
