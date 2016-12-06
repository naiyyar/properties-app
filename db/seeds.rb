# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# user = User.find(2)
# user.add_role :admin

Gcoordinate.where(zipcode: ['West Village','Stuyevesant','Roosevelt Island','Chelsea','Greenwich Village','East Village', 'Gramercy', 'Battery Park', 'Flatiron District', 'Financial District']).destroy_all
#Gcoordinate.where(neighborhood: ['West Village','Stuyevesant','Roosevelt Island','Chelsea','Greenwich Village','East Village', 'Gramercy', 'Battery Park', 'Flatiron District', 'Financial District']).destroy_all

# coords_10029 = [{ lng: -73.955778, lat: 40.787914 },
# 				{ lng: -73.950927, lat: 40.785866 },
# 				{ lng: -73.950434, lat: 40.78654 },
# 				{ lng: -73.944223, lat: 40.783933 },
# 				{ lng: -73.944723, lat: 40.783247 },
# 				{ lng: -73.943604, lat: 40.78265 },
# 				{ lng: -73.939719, lat: 40.785315 },
# 				{ lng: -73.935626, lat: 40.791263 },
# 				{ lng: -73.931094, lat: 40.79409 },
# 				{ lng: -73.93266,  lat: 40.795732 },
# 				{ lng: -73.935408, lat: 40.796004 },
# 				{ lng: -73.946462, lat: 40.800665 },
# 				{ lng: -73.94922,  lat: 40.79691 },
# 				{ lng: -73.955778, lat: 40.787914 } ]
# coords_10029.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], zipcode: '10029')
# end

# coords_10128 = [ { lng: -73.9670849, lat: 40.7845059 },
# 				 { lng: -73.9635658, lat: 40.7830111 },
# 				 { lng: -73.9631367, lat: 40.7817113 },
# 				 { lng: -73.9618063, lat: 40.7812238 },
# 				 { lng: -73.9606905, lat: 40.7810614 },
# 				 { lng: -73.9603472, lat: 40.7815488 },
# 				 { lng: -73.9586306, lat: 40.7808014 },
# 				 { lng: -73.9581156, lat: 40.7816463 },
# 				 { lng: -73.9577293, lat: 40.7821987 },
# 				 { lng: -73.9544678, lat: 40.7807364 },
# 				 { lng: -73.9549398, lat: 40.7800215 },
# 				 { lng: -73.9512062, lat: 40.7785266 },
# 				 { lng: -73.9507771, lat: 40.7791766 },
# 				 { lng: -73.9460993, lat: 40.7771942 },
# 				 { lng: -73.9442968, lat: 40.7764143 },
# 				 { lng: -73.9446831, lat: 40.7757643 },
# 				 { lng: -73.9442539, lat: 40.7756668 },
# 				 { lng: -73.9429235, lat: 40.7774867 },
# 				 { lng: -73.9424086, lat: 40.7778442 },
# 				 { lng: -73.9426231, lat: 40.7786241 },
# 				 { lng: -73.9423227, lat: 40.7795015 },
# 				 { lng: -73.943224,  lat: 40.7799565 },
# 				 { lng: -73.9436102, lat: 40.7815488 },
# 				 { lng: -73.9432669, lat: 40.7827511 },
# 				 { lng: -73.9472151, lat: 40.7842784 },
# 				 { lng: -73.9464855, lat: 40.7850258 },
# 				 { lng: -73.9503908, lat: 40.786553 },
# 				 { lng: -73.9509487, lat: 40.7856756 },
# 				 { lng: -73.9560986, lat: 40.7880801 },
# 				 { lng: -73.9567423, lat: 40.7891524 },
# 				 { lng: -73.9588881, lat: 40.7900946 },
# 				 { lng: -73.9601326, lat: 40.7903546 },
# 				 { lng: -73.9618063, lat: 40.7913943 },
# 				 { lng: -73.9631796, lat: 40.7918492 },
# 				 { lng: -73.9646816, lat: 40.7901271 },
# 				 { lng: -73.9647245, lat: 40.7892174 },
# 				 { lng: -73.9657974, lat: 40.7888275 },
# 				 { lng: -73.9669132, lat: 40.7879177 },
# 				 { lng: -73.9676857, lat: 40.786553 },
# 				 { lng: -73.9679003, lat: 40.7855457 },
# 				 { lng: -73.9670849, lat: 40.7845059 }]
# coords_10128.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], zipcode: '10128')
# end



# coords_10035 = [{ lng: -73.936239, lat: 40.785687 },
# 				{ lng: -73.935433, lat: 40.783249 },
# 				{ lng: -73.927116, lat: 40.781079 },
# 				{ lng: -73.922811, lat: 40.783597 },
# 				{ lng: -73.92216,  lat: 40.785502 },
# 				{ lng: -73.918481, lat: 40.789428 },
# 				{ lng: -73.915194, lat: 40.791947 },
# 				{ lng: -73.913835, lat: 40.794664 },
# 				{ lng: -73.9152,   lat: 40.796804 },
# 				{ lng: -73.920371, lat: 40.799433 },
# 				{ lng: -73.921888, lat: 40.80153 },
# 				{ lng: -73.925603, lat: 40.801998 },
# 				{ lng: -73.927599, lat: 40.79803 },
# 				{ lng: -73.926963, lat: 40.795242 },
# 				{ lng: -73.928268, lat: 40.792299 },
# 				{ lng: -73.926135, lat: 40.79135 },
# 				{ lng: -73.930868, lat: 40.791093 },
# 				{ lng: -73.936239, lat: 40.785687 }]

# coords_10035.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], zipcode: '10035')
# end



roosevelt = [{ lng: -73.9616776, lat: 40.7497279 }, { lng: -73.959446, lat: 40.7511583 },
			 { lng: -73.957901,  lat: 40.7520036 }, { lng: -73.9525795, lat: 40.757205 },
			 { lng: -73.9521503, lat: 40.7578552 }, { lng: -73.951292, lat: 40.7587004 },
			 { lng: -73.9493179, lat: 40.7605207 }, { lng: -73.9420223, lat: 40.7689718 }, 
			 { lng: -73.9408207, lat: 40.7697518 }, { lng: -73.940134, lat: 40.7713119 },
			 { lng: -73.9400482, lat: 40.7731969 }, { lng: -73.9409065, lat: 40.7725469 },
			 { lng: -73.9425373, lat: 40.7720269 }, { lng: -73.9434814, lat: 40.7707918 },
			 { lng: -73.9449406, lat: 40.7696218 }, { lng: -73.9592743, lat: 40.753239 },
			 { lng: -73.9600468, lat: 40.7517435 }, { lng: -73.9613342, lat: 40.7503781 },
			 { lng: -73.9616776, lat: 40.7497279 }]
roosevelt.each do |coord|
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Roosevelt Island')
end

stuyvesant = [  { lng: -73.7828064, lat: 42.3128621 },
				{ lng: -73.7677002, lat: 42.308292 },
				{ lng: -73.7580872, lat: 42.3164163 },
				{ lng: -73.7512207, lat: 42.3113388 },
				{ lng: -73.7464142, lat: 42.3184472 },
				{ lng: -73.7450409, lat: 42.334692 },
				{ lng: -73.7450409, lat: 42.3392601 },
				{ lng: -73.7422943, lat: 42.3448428 },
				{ lng: -73.7340546, lat: 42.3473803 },
				{ lng: -73.7148285, lat: 42.3702128 },
				{ lng: -73.7477875, lat: 42.3818796 },
				{ lng: -73.7374878, lat: 42.4062207 },
				{ lng: -73.7223816, lat: 42.4117975 },
				{ lng: -73.7347412, lat: 42.4199083 },
				{ lng: -73.7210083, lat: 42.4234565 },
				{ lng: -73.719635,  lat: 42.4351134 },
				{ lng: -73.7436676, lat: 42.4361269 },
				{ lng: -73.7477875, lat: 42.4599404 },
				{ lng: -73.7814331, lat: 42.4619666 },
				{ lng: -73.7793732, lat: 42.4244702 },
				{ lng: -73.7848663, lat: 42.3960797 },
				{ lng: -73.7931061, lat: 42.3788363 },
				{ lng: -73.7917328, lat: 42.3549921 },
				{ lng: -73.7841797, lat: 42.3377374 },
				{ lng: -73.7828064, lat: 42.3128621 }
			  ]
stuyvesant.each do |coord|
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Stuyvesant')
end

greenwich = [{ lng: -74.0029621, lat: 40.7283645 }, 
			 { lng: -73.9967823, lat: 40.725405 },
			 { lng: -73.9952803, lat: 40.7250797 }, 
			 { lng: -73.9925337, lat: 40.724104 },
			 { lng: -73.9906883, lat: 40.729893 },
			 { lng: -73.9924479, lat: 40.7306085 },
			 { lng: -73.991375,  lat: 40.7319093 },
			 { lng: -73.99086,   lat: 40.7348685 },
			 { lng: -73.9997864, lat: 40.7386081 },
			 { lng: -74.0012026, lat: 40.736592 },
			 { lng: -73.9997005, lat: 40.7341857 }, 
			 { lng: -73.9996147, lat: 40.7336003 }, 
			 { lng: -74.0023184, lat: 40.7296654 }, 
			 { lng: -74.0029621, lat: 40.7283645 }]
greenwich.each do |coord|
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Greenwich Village')
end

gramercy = [{ lng: -73.9863539, lat: 40.7402339 },
			{ lng: -73.9900017, lat: 40.7351937 },
			{ lng: -73.9899588, lat: 40.7343157 },
			{ lng: -73.9825988, lat: 40.731389 },
			{ lng: -73.9785004, lat: 40.7369172 },
			{ lng: -73.9863539, lat: 40.7402339 }]
gramercy.each do |coord|
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Gramercy')
end

battery_park = [{ lng: -74.0166521, lat: 40.7185748 },
				{ lng: -74.0193558, lat: 40.7062461 },
				{ lng: -74.0188408, lat: 40.704717 },
				{ lng: -74.0174675, lat: 40.7045218 },
				{ lng: -74.0163946, lat: 40.7064413 },
				{ lng: -74.0151501, lat: 40.7100848 },
				{ lng: -74.0129185, lat: 40.7183471 },
				{ lng: -74.0166521, lat: 40.7185748 }]
battery_park.each do |coord|
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Battery Park')
end

flatiron = [{ lng: -73.992877,  lat: 40.7429327 },
			{ lng: -73.9968252, lat: 40.7373074 },
			{ lng: -73.99086,   lat: 40.7348685 },
			{ lng: -73.9900017, lat: 40.7351937 },
			{ lng: -73.9863539, lat: 40.7402339 },
			{ lng: -73.992877,  lat: 40.7429327 }]
flatiron.each do |coord|
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Flatiron District')
end

chelsea = [ { lng: -73.9968252, lat: 40.7373074 },
			{ lng: -73.9896584, lat: 40.7472895 },
			{ lng: -74.0090561, lat: 40.7554496 },
			{ lng: -74.0099144, lat: 40.7541493 },
			{ lng: -74.011116,  lat: 40.7506382 },
			{ lng: -74.012661,  lat: 40.7433553 },
			{ lng: -74.0093994, lat: 40.7430302 },
			{ lng: -73.9968252, lat: 40.7373074 }]
chelsea.each do |coord|
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Chelsea')
end

financial = [{ lng: -74.0138626, lat: 40.7136956 },
			 { lng: -74.0167379, lat: 40.7051725 },
			 { lng: -74.0176392, lat: 40.7040663 },
			 { lng: -74.017725,  lat: 40.7030903 },
			 { lng: -74.0151501, lat: 40.7006502 },
			 { lng: -74.0149355, lat: 40.700943  },
			 { lng: -74.0140343, lat: 40.7003574 },
			 { lng: -74.0124035, lat: 40.7002598 },
			 { lng: -74.0108156, lat: 40.7007153 },
			 { lng: -73.9978552, lat: 40.7062135 },
			 { lng: -74.0048504, lat: 40.711874  },
			 { lng: -74.0054512, lat: 40.7120041 },
			 { lng: -74.007597,  lat: 40.7116462 },
			 { lng: -74.008112,  lat: 40.7120041 },
			 { lng: -74.0087128, lat: 40.711386  },
			 { lng: -74.0138626, lat: 40.7136956 }]
financial.each do |coord|
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Financial District')
end

east_village = [{ lng: -73.9717197, lat: 40.7267384 },
				{ lng: -73.99086, 	lat: 40.7348685 },
				{ lng: -73.991375,  lat: 40.7319093 },
				{ lng: -73.9924479, lat: 40.7306085 },
				{ lng: -73.9906883, lat: 40.729893 },
				{ lng: -73.9925337, lat: 40.724104 },
				{ lng: -73.9774275, lat: 40.7193554 },
				{ lng: -73.9734793, lat: 40.718835 },
				{ lng: -73.9717197, lat: 40.7267384 }]
east_village.each do |coord|
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'East Village')
end

west_village = [{ lng: -74.011631, 	lat: 40.7278767 },
				{ lng: -74.0033054, lat: 40.7272913 },
			    { lng: -74.0029621, lat: 40.7283645 },
			    { lng: -73.9996147, lat: 40.7336003 },
			    { lng: -74.0012026, lat: 40.736592 },
			    { lng: -73.9997864, lat: 40.7386081 },
			    { lng: -74.0093994, lat: 40.7430302 },
			    { lng: -74.012661,  lat: 40.7433553 },
			    { lng: -74.0157509, lat: 40.7281369 },
			    { lng: -74.011631,  lat: 40.7278767 }]
west_village.each do |coord|
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'West Village')
end

# coords_10040 = [{ lng: -73.9286327, lat: 40.8469954 },
# 				{ lng: -73.9195347, lat: 40.8590708 },
# 				{ lng: -73.9215088, lat: 40.8606937 },
# 				{ lng: -73.9231396, lat: 40.8591357 },
# 				{ lng: -73.9269161, lat: 40.8654971 },
# 				{ lng: -73.9298344, lat: 40.8660164 },
# 				{ lng: -73.9312077, lat: 40.8686776 },
# 				{ lng: -73.9388466, lat: 40.8562145 },
# 				{ lng: -73.927002, 	lat: 40.8522543 },
# 				{ lng: -73.9302635, lat: 40.8477096 },
# 				{ lng: -73.9286327, lat: 40.8469954 }]
# coords_10040.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], zipcode: '10040')
# end
