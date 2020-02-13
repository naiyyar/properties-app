module BuildingAmenities
	class << self
		def all_amenities
			amenities = {
				childrens_playroom: 		'Childrens Playroom',
				courtyard: 							'Courtyard',
				garage: 								'Garage',
				management_company_run: 'Management Company Run'
			}
			@building_amenities ||= col1_popular_building_amenities.merge(col2_popular_building_amenities.merge(other_building_amenities.merge(amenities)))
		end

		def col1_popular_building_amenities
			@col1_popular_building_amenities ||= {
				no_fee: 					 	'No Fee Building',
				pets_allowed_cats: 	'Cats Allowed',
				pets_allowed_dogs: 	'Dogs Allowed',
				doorman: 						'Doorman',
			}
		end

		def col2_popular_building_amenities
			@col2_popular_building_amenities ||= {
				elevator: 					'Elevator',
				laundry_facility: 	'Laundry in Building',
				walk_up: 						'Walk up',
				courtyard: 					'Courtyard'
			}
		end

		def other_building_amenities
			@other_building_amenities ||= {
				parking: 								'Parking/Garage',
				gym: 										'Gym',
				live_in_super: 					'Live in super',
				roof_deck: 							'Roof Deck',
				swimming_pool: 					'Swimming Pool'
			}
		end
	end
end