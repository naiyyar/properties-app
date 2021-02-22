module BuildingAmenities
	class << self
		def common
			{
				childrens_playroom: 		'Childrens Playroom',
				pets_allowed_cats: 			'Cats Allowed',
				pets_allowed_dogs: 			'Dogs Allowed',
				doorman: 								'Doorman',
				elevator: 							'Elevator',
				gym: 										'Gym',
				laundry_facility: 			'Laundry in Building',
				live_in_super: 					'Live in super',
				management_company_run: 'Management Company',
				parking: 								'Parking / Garage',
				roof_deck: 							'Roof Deck',
				swimming_pool: 					'Swimming Pool',
				walk_up: 								'Walk up'
			}
		end
		
		def building_edit_amenities
			common.merge!({
				courtyard: 'Courtyard',
				deposit_free: 'Deposit Free'
			}).sort_by{|_k, value| value}.to_h
		end
		
		def all_amenities
			building_edit_amenities
		end

		def listing_amenities
			common.merge!({
											balcony: 'Balcony',
											dishwasher: 'Dishwasher',
											furnished: 'Furnished',
											laundary_in_unit: 'Laundry In Unit',
										}).sort_by{|_k, value| value}.to_h
		end

		# for filtering purpose
		def col1_popular_building_amenities
			{
				no_fee: 					 	'No Fee Building',
				pets_allowed_cats: 	'Cats Allowed',
				pets_allowed_dogs: 	'Dogs Allowed',
				doorman: 						'Doorman',
			}
		end

		def col2_popular_building_amenities
			{
				elevator: 					'Elevator',
				laundry_facility: 	'Laundry In Building',
				walk_up: 						'Walk Up',
				courtyard: 					'Courtyard'
			}
		end

		def other_building_amenities
			{
				gym: 										'Gym',
				live_in_super: 					'Live In Super',
				parking: 								'Parking/Garage',
				roof_deck: 							'Roof Deck',
				swimming_pool: 					'Swimming Pool'
			}
		end
	end
end