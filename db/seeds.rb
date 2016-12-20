# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# user = User.find(2)
# user.add_role :admin

# TODO:
# Central Harlem
# South Harlem
# East Harlem
# Hamilton Heights
# Inwood
# Manhattanville
# Marble Hill
# Washington Heights
# Fort George
# Hudson Heights
# West Harlem
# Carnegie Hill
# Lenox Hill
# Upper Carnegie Hill
# Yorkville
# Lincoln Square
# Manhattan Valley
# Morningside Heights

Gcoordinate.where(zipcode: ['10035']).destroy_all
Gcoordinate.where(neighborhood: ['Soho']).destroy_all


# gramercy = [{ lng: -73.9863539, lat: 40.7402339 },
# 			{ lng: -73.9900017, lat: 40.7351937 },
# 			{ lng: -73.9899588, lat: 40.7343157 },
# 			{ lng: -73.9825988, lat: 40.731389 },
# 			{ lng: -73.9785004, lat: 40.7369172 },
# 			{ lng: -73.9863539, lat: 40.7402339 }]
# gramercy.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Gramercy Park')
# end

# battery_park = [{ lng: -74.0166521, lat: 40.7185748 },
# 				{ lng: -74.0193558, lat: 40.7062461 },
# 				{ lng: -74.0188408, lat: 40.704717 },
# 				{ lng: -74.0174675, lat: 40.7045218 },
# 				{ lng: -74.0163946, lat: 40.7064413 },
# 				{ lng: -74.0151501, lat: 40.7100848 },
# 				{ lng: -74.0129185, lat: 40.7183471 },
# 				{ lng: -74.0166521, lat: 40.7185748 }]
# battery_park.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Battery Park City')
# end


# tribeca = [ { lng: -74.0109444, lat: 40.7257952 },
# 			{ lng: -74.0133905, lat: 40.7144438 },
# 			{ lng: -74.0138197, lat: 40.7136305 },
# 			{ lng: -74.0091848, lat: 40.7115487 },
# 			{ lng: -74.0084553, lat: 40.7116137 },
# 			{ lng: -74.0018463, lat: 40.7194204 },
# 			{ lng: -74.0109444, lat: 40.7257952 }]
# tribeca.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Tribeca')
# end

# lower_east_side = [	{ lng: -73.9925766, lat: 40.7242016 },
# 					{ lng: -73.9958382, lat: 40.7165256 },
# 					{ lng: -73.99189, 	lat: 40.7092715 },
# 					{ lng: -73.9890146, lat: 40.709727 },
# 					{ lng: -73.9887571, lat: 40.7088161 },
# 					{ lng: -73.9809465, lat: 40.7096294 },
# 					{ lng: -73.9809895, lat: 40.7099547 },
# 					{ lng: -73.9778137, lat: 40.7103125 },
# 					{ lng: -73.9762688, lat: 40.7115161 },
# 					{ lng: -73.9733076, lat: 40.7185422 },
# 					{ lng: -73.97717,	lat: 40.7192578 },
# 					{ lng: -73.978672,	lat: 40.7198758 },
# 					{ lng: -73.9925766,	lat: 40.7242016 }]
# lower_east_side.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Lower East Side')
# end

soho = [{ lng: -74.0018463, lat: 40.7194204 },
		{ lng: -73.9999151, lat: 40.7180543 },
		{ lng: -73.9976406, lat: 40.720819 },
		{ lng: -73.9966536, lat: 40.7233885 },
		{ lng: -73.9953232, lat: 40.7251123 },
		{ lng: -73.9967823, lat: 40.725405 },
		{ lng: -74.0026617, lat: 40.728397 },
		{ lng: -74.0092707, lat: 40.7290149 },
		{ lng: -74.0094852, lat: 40.7278116 },
		{ lng: -74.0150213, lat: 40.7282995 },
		{ lng: -74.0154076, lat: 40.7263481 },
		{ lng: -74.0109444, lat: 40.7257952 },
		{ lng: -74.0018463, lat: 40.7194204 }]
soho.each do |coord|
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'SoHo')
end
# stuyvesant_town = [ { lng: -73.9799595, lat: 40.7349661 },
# 					{ lng: -73.9825988, lat: 40.7313402 },
# 					{ lng: -73.9757109, lat: 40.7283808 },
# 					{ lng: -73.973887, lat: 40.7309662 },
# 					{ lng: -73.974402, lat: 40.7327223 },
# 					{ lng: -73.9799595, lat: 40.7349661 }]
# stuyvesant_town.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Stuyvesant Town')
# end

# east_harlem = [ { lng: -73.9414215, lat: 40.7821012 },
# 				{ lng: -73.9300919, lat: 40.7932787 },
# 				{ lng: -73.9282036, lat: 40.7966576 },
# 				{ lng: -73.9292336, lat: 40.8026352 },
# 				{ lng: -73.9342117, lat: 40.8096517 },
# 				{ lng: -73.9340401, lat: 40.8184862 },
# 				{ lng: -73.9551544, lat: 40.78873 },
# 				{ lng: -73.9414215, lat: 40.7821012 }]
# east_harlem.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'East Harlem')
# end

east_harlem_10035 = [	{ lng: -73.9341259, lat: 40.8173819 },
						{ lng: -73.9464855, lat: 40.8004911 },
						{ lng: -73.9313793, lat: 40.7941235 },
						{ lng: -73.93507, 	lat: 40.7919791 },
						{ lng: -73.9372158, lat: 40.7897047 },
						{ lng: -73.9382458, lat: 40.7872353 },
						{ lng: -73.9397907, lat: 40.7857406 },
						{ lng: -73.9368725, lat: 40.7818413 },
						{ lng: -73.931551, 	lat: 40.7819713 },
						{ lng: -73.9278603, lat: 40.7802165 },
						{ lng: -73.9255428, lat: 40.7819713 },
						{ lng: -73.9226246, lat: 40.7831411 },
						{ lng: -73.9215088, lat: 40.7858056 },
						{ lng: -73.9172173, lat: 40.7899647 },
						{ lng: -73.913784, 	lat: 40.7929538 },
						{ lng: -73.9131832, lat: 40.7947733 },
						{ lng: -73.915844, 	lat: 40.7978921 },
						{ lng: -73.9202213, lat: 40.7994515 },
						{ lng: -73.9221096, lat: 40.8021804 },
						{ lng: -73.9273453, lat: 40.8021804 },
						{ lng: -73.9341259, lat: 40.8173819 }]
east_harlem_10035.each do |coord|
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], zipcode: '10035')
end

# chinatown = [{ lng: -73.9987779, lat: 40.713533 },
# 			{ lng: -73.9981556, lat: 40.7137281 },
# 			{ lng: -73.9976406, lat: 40.7134516 },
# 			{ lng: -73.9902163, lat: 40.7140534 },
# 			{ lng: -73.9902377, lat: 40.7146227 },
# 			{ lng: -73.9897442, lat: 40.7155497 },
# 			{ lng: -73.9954305, lat: 40.7172412 },
# 			{ lng: -73.9947653, lat: 40.7184609 },
# 			{ lng: -73.9964819, lat: 40.7190139 },
# 			{ lng: -73.9977908, lat: 40.7168183 },
# 			{ lng: -73.9986062, lat: 40.7170948 },
# 			{ lng: -74.0018892, lat: 40.7194042 },
# 			{ lng: -74.004035,  lat: 40.7168834 },
# 			{ lng: -74.0005803, lat: 40.7152244 },
# 			{ lng: -74.0004516, lat: 40.7143299 },
# 			{ lng: -73.9987779, lat: 40.713533}]
# chinatown.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Chinatown')
# end

# civic_center = [{ lng: -74.0013742, lat: 40.709792  },
# 				{ lng: -74.0006018, lat: 40.7108981 },
# 				{ lng: -73.9982629, lat: 40.7132239 },
# 				{ lng: -73.9987779, lat: 40.713533  },
# 				{ lng: -74.0004516, lat: 40.7143299 },
# 				{ lng: -74.0005803, lat: 40.7152244 },
# 				{ lng: -74.0007734, lat: 40.7153383 },
# 				{ lng: -73.9999151, lat: 40.7165743 },
# 				{ lng: -74.0024257, lat: 40.7177291 },
# 				{ lng: -74.0029407, lat: 40.7171273 },
# 				{ lng: -74.002769, 	lat: 40.7170297 },
# 				{ lng: -74.003284, 	lat: 40.7165093 },
# 				{ lng: -74.004035, 	lat: 40.7168834 },
# 				{ lng: -74.0086269, lat: 40.7113372 },
# 				{ lng: -74.0052366, lat: 40.7121017 },
# 				{ lng: -74.0036917, lat: 40.7114023 },
# 				{ lng: -74.0013742, lat: 40.709792 }]
# civic_center.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Civic Center')
# end

# little_italy = [{ lng: -73.9977908, lat: 40.7168183 },
# 				{ lng: -73.9964819, lat: 40.7190139 },
# 				{ lng: -73.9947653, lat: 40.7184609 },
# 				{ lng: -73.994379, 	lat: 40.7194855 },
# 				{ lng: -73.9998937, lat: 40.721746 	},
# 				{ lng: -74.0018892, lat: 40.7194042 },
# 				{ lng: -73.998735, 	lat: 40.7171598 },
# 				{ lng: -73.9977908, lat: 40.7168183 }]
# little_italy.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Little Italy')
# end

# nolita = [	{ lng: -73.9981341, lat: 40.7211118 },
# 			{ lng: -73.994379,  lat: 40.7194855 },
# 			{ lng: -73.9944649, lat: 40.7193391 },
# 			{ lng: -73.9933491, lat: 40.7190789 },
# 			{ lng: -73.9910531, lat: 40.7236487 },
# 			{ lng: -73.9953661, lat: 40.7250797 },
# 			{ lng: -73.9967394, lat: 40.7235186 },
# 			{ lng: -73.9971256, lat: 40.7223315 },
# 			{ lng: -73.9981341, lat: 40.7211118 }]
# nolita.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Nolita')
# end

# sp = [  { lng: -73.9620423, lat: 40.7598544 },
# 		{ lng: -73.9648747, lat: 40.7560023 },
# 		{ lng: -73.9618921, lat: 40.7547182 },
# 		{ lng: -73.960433, 	lat: 40.7558235 },
# 		{ lng: -73.958416, 	lat: 40.7583916 },
# 		{ lng: -73.9608622, lat: 40.7594968 },
# 		{ lng: -73.9620423, lat: 40.7598544 }]
# sp.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Sutton Place')
# end

# uws = [ { lng: -73.9819336, lat: 40.7680617 },
# 		{ lng: -73.958416,  lat: 40.8004261 },
# 		{ lng: -73.9728355, lat: 40.8065333 },
# 		{ lng: -73.9963531, lat: 40.7737819 },
# 		{ lng: -73.9819336, lat: 40.7680617 }]
# uws.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Upper West Side')
# end

# ues = [ { lng: -73.9576435, lat: 40.7583103 },
# 		{ lng: -73.9407349, lat: 40.7756668 },
# 		{ lng: -73.9426231, lat: 40.7832061 },
# 		{ lng: -73.9551544, lat: 40.78873 },
# 		{ lng: -73.9724922, lat: 40.7649414 },
# 		{ lng: -73.9576435, lat: 40.7583103 }]
# ues.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Upper East Side')
# end