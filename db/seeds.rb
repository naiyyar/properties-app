### setting up coliving number form 5 to 9
# step1: Price.where(bed_type: 5).update_all(bed_type: 9)

# step2: RentMedian.where(bed_type: 5).update_all(bed_type: 9)

# step3: Price and RentMedian form changes

Building.find_each do |building|
	bedroom_types = [	building.studio, 
									 	building.one_bed, 
									 	building.two_bed, 
									 	building.three_bed, 
									 	building.four_plus_bed].compact
	
	amenities = []
  amenities << 'parking'								 if building.parking
  amenities << 'pets_allowed_cats'			 if building.pets_allowed_cats
  amenities << 'pets_allowed_dogs'			 if building.pets_allowed_dogs
  amenities << 'doorman'								 if building.doorman
  amenities << 'elevator'							 	 if building.elevator
  amenities << 'gym'										 if building.gym
  amenities << 'laundry_facility' 		 	if building.laundry_facility
  amenities << 'live_in_super'          if building.live_in_super
  amenities << 'management_company_run' if building.management_company_run
  amenities << 'roof_deck'							 if building.roof_deck
  amenities << 'swimming_pool'				 if building.swimming_pool
  amenities << 'walk_up'							 if building.walk_up
  amenities << 'courtyard'						 if building.courtyard
  amenities << 'deposit_free'					 if building.deposit_free
  #
  building.update_columns(amenities: amenities, bedroom_types: bedroom_types)
end      


 # amenities.merge!(:parking => 'Parking / Garage') 									if building.parking
 #  amenities.merge!(:pets_allowed_cats => 'Cats Allowed')  					if building.pets_allowed_cats
 #  amenities.merge!(:pets_allowed_dogs => 'Dogs Allowed')  					if building.pets_allowed_dogs
 #  amenities.merge!(:doorman => 'Doorman')          									if building.doorman
 #  amenities.merge!(:elevator => 'Elevator')         								if building.elevator
 #  amenities.merge!(:gym => 'gym')              											if building.gym
 #  amenities.merge!(:laundry_facility => 'Laundry in Building') 			if building.laundry_facility
 #  amenities.merge!(:live_in_super => 'Live in super')              	if building.live_in_super
 #  amenities.merge!(:management_company_run => 'Management Company') if building.management_company_run
 #  amenities.merge!(:roof_deck => 'Roof Deck') 											if building.roof_deck
 #  amenities.merge!(:swimming_pool => 'Swimming Pool') 							if building.swimming_pool
 #  amenities.merge!(:walk_up => 'Walk up') 													if building.walk_up
 #  amenities.merge!(:courtyard => 'Courtyard') 											if building.courtyard
 #  amenities.merge!(:deposit_free => 'Deposit Free') 								if building.deposit_free           