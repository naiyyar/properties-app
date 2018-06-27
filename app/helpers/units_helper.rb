module UnitsHelper
	def unit_amenities
		{
			balcony: 'Balcony',
			board_approval_required: 'Board Approval Required',
			can_be_converted: 'Can be converted',
			converted_unit: 'Converted Unit',
			dishwasher: 'Dishwasher',
			fireplace: 'Fireplace',
			furnished: 'Furnished',
			guarantors_accepted: 'Guarantors Accepted',
			loft: 'Loft',
			private_landlord: 'Private Landlord',
			rent_controlled: 'Rent Controlled',
			storage_available: 'Storage Available',
			sublet: 'Sublet',
			terrace: 'Terrace',
			dryer_in_unit: 'Washer/Dryer'
		}
	end

	def bedroom_options
		[['Studio',0],['1 Bed', 1],['2 Bed',2],['3 Bed',3],['4+ Bed',4]]
	end
end
