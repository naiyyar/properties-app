# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# user = User.find(2)
# user.add_role :admin

Gcoordinate.where(zipcode: ['10004','10023','10024','10025']).destroy_all
coords_10004 = [	{ lng: -74.0155363, lat: 40.7004062 },
									{ lng: -74.0152144, lat: 40.7002598 },
									{ lng: -74.0148711, lat: 40.7001785 },
									{ lng: -74.0096569, lat: 40.7001947 },
									{ lng: -74.0104294, lat: 40.7012033 },
									{ lng: -74.0102577, lat: 40.7012847 },
									{ lng: -74.0094209, lat: 40.7002761 },
									{ lng: -74.009335,  lat: 40.7005364 },
									{ lng: -74.0098715, lat: 40.7014311 },
									{ lng: -74.0076828, lat: 40.7025047 },
									{ lng: -74.0066314, lat: 40.7015775 },
									{ lng: -74.0062881, lat: 40.7017401 },
									{ lng: -74.0076828, lat: 40.7030253 },
									{ lng: -74.0080261, lat: 40.7032367 },
									{ lng: -74.0084982, lat: 40.7036597 },
									{ lng: -74.0083265, lat: 40.7037898 },
									{ lng: -74.0087128, lat: 40.7041639 },
									{ lng: -74.0089488, lat: 40.7040989 },
									{ lng: -74.0094638, lat: 40.7045218 },
									{ lng: -74.0088415, lat: 40.7048309 },
									{ lng: -74.0088844, lat: 40.7049447 },
									{ lng: -74.0096354, lat: 40.7047495 },
									{ lng: -74.0099788, lat: 40.7051725 },
									{ lng: -74.0115666, lat: 40.7049447 },
									{ lng: -74.0111589, lat: 40.7062949 },
									{ lng: -74.0124893, lat: 40.7068154 },
									{ lng: -74.013176,  lat: 40.7058557 },
									{ lng: -74.0142488, lat: 40.7063111 },
									{ lng: -74.0143776, lat: 40.7060834 },
									{ lng: -74.0151501, lat: 40.7062623 },
									{ lng: -74.0151072, lat: 40.7064575 },
									{ lng: -74.0158367, lat: 40.706669  },
									{ lng: -74.0158796, lat: 40.7064738 },
									{ lng: -74.0166521, lat: 40.7064413 },
									{ lng: -74.0175748, lat: 40.7068642 },
									{ lng: -74.0179396, lat: 40.706181  },
									{ lng: -74.0180254, lat: 40.7058231 },
									{ lng: -74.0179181, lat: 40.7053189 },
									{ lng: -74.0174246, lat: 40.7049447 },
									{ lng: -74.0166092, lat: 40.7046357 },
									{ lng: -74.0171885, lat: 40.7043429 },
									{ lng: -74.0174031, lat: 40.7042453 },
									{ lng: -74.0180898, lat: 40.7034157 },
									{ lng: -74.0176606, lat: 40.7020167 },
									{ lng: -74.0155363, lat: 40.7004062 }]
 
coords_10004.each do |coord|
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], zipcode: '10004')
end

coords_10023 = [{ lng: -73.988774, lat: 40.776673 },{ lng: -73.989994, lat: 40.772242 },{ lng: -73.984769, lat: 40.769218 },{ lng: -73.982067, lat: 40.768481 },{lng: -73.981648, lat: 40.768436 },{ lng: -73.974067, lat: 40.778805 },{ lng: -73.977562, lat: 40.780909 },{ lng: -73.981064, lat: 40.781751 },{ lng: -73.982126, lat: 40.783027 },{ lng: -73.984452, lat: 40.783192 },{ lng: -73.985679, lat: 40.780313 },{ lng: -73.986544, lat: 40.780658 },{ lng: -73.988774, lat: 40.776673 }]
coords_10023.each do |coord|
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], zipcode: '10023')
end

coords_10024 = [{ lng: -73.98814, lat: 40.781409 },{ lng: -73.987308, lat: 40.781041 },{ lng: -73.986544, lat: 40.780658 },{ lng: -73.985679, lat: 40.780313 },{lng: -73.984452, lat: 40.783192 },{ lng: -73.982126, lat: 40.783027 },{ lng: -73.981064, lat: 40.781751 },{ lng: -73.977562, lat: 40.780909 },{ lng: -73.974067, lat: 40.778805 },{ lng: -73.96701, lat: 40.788476 },{ lng: -73.977092, lat: 40.792724 },{ lng: -73.976795, lat: 40.794315 },{ lng: -73.974256, lat: 40.796588 },{ lng: -73.973736, lat: 40.798608 },{ lng: -73.970273, lat: 40.80236 },{ lng: -73.966518, lat: 40.808226 },{ lng: -73.9659, lat: 40.808806 },{ lng: -73.964424, lat: 40.810755 },{ lng: -73.964019, lat: 40.811331 },{ lng: -73.961398, lat: 40.815146 },{ lng: -73.961276, lat: 40.816607 },{ lng: -73.960687, lat: 40.817511 },{ lng: -73.962067, lat: 40.818099 },{ lng: -73.964167, lat: 40.81579 },{ lng: -73.972899, lat: 40.803383 },{ lng: -73.98814, lat: 40.781409 } ]
coords_10024.each do |coord|
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], zipcode: '10024')
end

coords_10025 = [{ lng: -73.976795, lat: 40.794315 },{ lng: -73.977092, lat: 40.792724 },{ lng: -73.96701, lat: 40.788476 },{ lng: -73.960037, lat: 40.798038 },{lng: -73.958195, lat: 40.800553 },{ lng: -73.959647, lat: 40.801156 },{ lng: -73.958249, lat: 40.803107 },{ lng: -73.958182, lat: 40.805597 },{ lng: -73.956806, lat: 40.807546 },{ lng: -73.954966, lat: 40.810064 },{ lng: -73.957808, lat: 40.811264 },{ lng: -73.957091, lat: 40.81008 },{ lng: -73.959826, lat: 40.805435 },{ lng: -73.962008, lat: 40.805509 },{ lng: -73.964848, lat: 40.806707 },{ lng: -73.963903, lat: 40.808004 },{ lng: -73.9659, lat: 40.808806 },{ lng: -73.966518, lat: 40.808226 },{ lng: -73.970273, lat: 40.80236 },{ lng: -73.973736, lat: 40.798608 },{ lng: -73.974256, lat: 40.796588 },{ lng: -73.976795, lat: 40.794315 }]
coords_10025.each do |coord|
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], zipcode: '10025')
end

