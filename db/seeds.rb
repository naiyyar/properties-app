# # This file should contain all the record creation needed to seed the database with its default values.
# # The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
# #
# # Examples:
# #
# #   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
# #   Mayor.create(name: 'Emanuel', city: cities.first)


#user = User.find(2)
#user.add_role :admin

# # TODO:
# # Central Harlem
# # South Harlem
# # East Harlem
# # Hamilton Heights
# # Inwood
# # Manhattanville
# # Marble Hill
# # Washington Heights
# # Fort George
# # Hudson Heights
# # West Harlem
# # Carnegie Hill
# # Lenox Hill
# # Upper Carnegie Hill
# # Yorkville
# # Lincoln Square
# # Manhattan Valley
# # Morningside Heights

# # Gcoordinate.where(zipcode: ['10035']).destroy_all
# Gcoordinate.where(neighborhood: ['Lower Manhattan']).destroy_all

# manhattan = [	{ lng: -74.0088844, lat: 40.7424449 },
# 				{ lng: -74.0128326, lat: 40.7438756 },
# 				{ lng: -74.0205574, lat: 40.7044567 },
# 				{ lng: -74.0178108, lat: 40.7001622 },
# 				{ lng: -74.0162659, lat: 40.6992512 },
# 				{ lng: -74.0095711, lat: 40.6997718 },
# 				{ lng: -73.9990997, lat: 40.7064087 },
# 				{ lng: -73.9748955, lat: 40.7099221 },
# 				{ lng: -73.9714622, lat: 40.7256652 },
# 				{ lng: -74.0088844, lat: 40.7424449 }]
# manhattan.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Lower Manhattan')
# end

# s_harlem = [	{ lng: -73.9500904, lat: 40.8346581 },
# 				{ lng: -73.9602184, lat: 40.8229679 },
# 				{ lng: -73.9620209, lat: 40.8198502 },
# 				{ lng: -73.9562702, lat: 40.8133545 },
# 				{ lng: -73.9579868, lat: 40.8112108 },
# 				{ lng: -73.9551544, lat: 40.8101064 },
# 				{ lng: -73.9583302, lat: 40.8055588 },
# 				{ lng: -73.9580727, lat: 40.8032849 },
# 				{ lng: -73.9597893, lat: 40.8012708 },
# 				{ lng: -73.9492321, lat: 40.7969175 },
# 				{ lng: -73.9447689, lat: 40.803155 	},
# 				{ lng: -73.9431381, lat: 40.8024403 },
# 				{ lng: -73.9413357, lat: 40.805104 	},
# 				{ lng: -73.9427948, lat: 40.8057537 },
# 				{ lng: -73.9341259, lat: 40.8177067 },
# 				{ lng: -73.9347267, lat: 40.8280339 },
# 				{ lng: -73.9500904, lat: 40.8346581 }]
# s_harlem.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Harlem')
# end

# inwood = [	{ lng: -73.9273453, lat: 40.865627 },
# 			{ lng: -73.9229679, lat: 40.8588761 },
# 			{ lng: -73.9227962, lat: 40.8562794 },
# 			{ lng: -73.9221096, lat: 40.8560846 },
# 			{ lng: -73.920393, 	lat: 40.8579672 },
# 			{ lng: -73.920908, 	lat: 40.8584217 },
# 			{ lng: -73.9210796, lat: 40.8590059 },
# 			{ lng: -73.9216805, lat: 40.8594603 },
# 			{ lng: -73.921423, 	lat: 40.8601744 },
# 			{ lng: -73.9206505, lat: 40.8592656 },
# 			{ lng: -73.9195347, lat: 40.858941 	},
# 			{ lng: -73.9171314, lat: 40.8616025 },
# 			{ lng: -73.9150715, lat: 40.8632902 },
# 			{ lng: -73.9150715, lat: 40.8643288 },
# 			{ lng: -73.9138699, lat: 40.8646533 },
# 			{ lng: -73.9108658, lat: 40.869132 	},
# 			{ lng: -73.9103508, lat: 40.8713387 },
# 			{ lng: -73.9106083, lat: 40.8723772 },
# 			{ lng: -73.9113808, lat: 40.8732209 },
# 			{ lng: -73.9142132, lat: 40.874454 	},
# 			{ lng: -73.9160156, lat: 40.8745838 },
# 			{ lng: -73.9186764, lat: 40.8737401 },
# 			{ lng: -73.9185905, lat: 40.8747785 },
# 			{ lng: -73.9208221, lat: 40.8756222 },
# 			{ lng: -73.921423, 	lat: 40.8753626 },
# 			{ lng: -73.9212513, lat: 40.8747136 },
# 			{ lng: -73.920393, 	lat: 40.8739997 },
# 			{ lng: -73.9202213, lat: 40.8733507 },
# 			{ lng: -73.920908, 	lat: 40.8732858 },
# 			{ lng: -73.9219379, lat: 40.8737401 },
# 			{ lng: -73.9226246, lat: 40.8745838 },
# 			{ lng: -73.9225388, lat: 40.8755573 },
# 			{ lng: -73.9224529, lat: 40.8765308 },
# 			{ lng: -73.9226246, lat: 40.8773096 },
# 			{ lng: -73.9248562, lat: 40.8775692 },
# 			{ lng: -73.9264011, lat: 40.8776341 },
# 			{ lng: -73.9284611, lat: 40.8767255 },
# 			{ lng: -73.9322376, lat: 40.871144 	},
# 			{ lng: -73.9324093, lat: 40.8693916 },
# 			{ lng: -73.9273453, lat: 40.865627  }]
# inwood.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Inwood')
# end

# lincoln_square = [	{ lng: -73.9884138, lat: 40.7813538 },
# 					{ lng: -73.9905596, lat: 40.7817113 },
# 					{ lng: -73.9961386, lat: 40.7739119 },
# 					{ lng: -73.9848518, lat: 40.7691993 },
# 					{ lng: -73.9844227, lat: 40.7698168 },
# 					{ lng: -73.9822769, lat: 40.7689718 },
# 					{ lng: -73.9821911, lat: 40.7685492 },
# 					{ lng: -73.9815044, lat: 40.7685167 },
# 					{ lng: -73.9759684, lat: 40.7761868 },
# 					{ lng: -73.9884138, lat: 40.7813538 }]
# lincoln_square.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Lincoln Square')
# end

# yorkville = [   { lng: -73.9435673, lat: 40.7825562 },
# 				{ lng: -73.9527512, lat: 40.7865855 },
# 				{ lng: -73.9608192, lat: 40.7756018 },
# 				{ lng: -73.9476871, lat: 40.7701418 },
# 				{ lng: -73.946228,	lat: 40.7717669 },
# 				{ lng: -73.9427948, lat: 40.7749518 },
# 				{ lng: -73.9435673, lat: 40.7825562 }]
# yorkville.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Yorkville')
# end

# lenox_hill = [	{ lng: -73.9491034, lat: 40.7682892 },
# 				{ lng: -73.9503908, lat: 40.7688418 },
# 				{ lng: -73.9499187, lat: 40.7695568 },
# 				{ lng: -73.9647245, lat: 40.7756993 },
# 				{ lng: -73.973093, 	lat: 40.7642913 },
# 				{ lng: -73.9586735, lat: 40.7582453 },
# 				{ lng: -73.9559698, lat: 40.7607808 },
# 				{ lng: -73.9491034, lat: 40.7682892 }]
# lenox_hill.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Lenox Hill')
# end

# carnegie_hill = [	{ lng: -73.9540386, lat: 40.7787541 },
# 					{ lng: -73.9491892, lat: 40.7851232 },
# 					{ lng: -73.9557552, lat: 40.7878852 },
# 					{ lng: -73.9605188, lat: 40.7814513 },
# 					{ lng: -73.9540386, lat: 40.7787541 }]
# carnegie_hill.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Carnegie Hill')
# end

# washington_heights = [	{ lng: -73.9312935, lat: 40.8594603 },
# 						{ lng: -73.9391041, lat: 40.8579672 },
# 						{ lng: -73.9413357, lat: 40.8548512 },
# 						{ lng: -73.9420223, lat: 40.8535528 },
# 						{ lng: -73.9437389, lat: 40.8523193 },
# 						{ lng: -73.9476871, lat: 40.8507611 },
# 						{ lng: -73.9465714, lat: 40.8490731 },
# 						{ lng: -73.9470005, lat: 40.8473201 },
# 						{ lng: -73.9459705, lat: 40.8444632 },
# 						{ lng: -73.9463139, lat: 40.8436191 },
# 						{ lng: -73.9486313, lat: 40.839918 	},
# 						{ lng: -73.9500904, lat: 40.8346581 },
# 						{ lng: -73.9347267, lat: 40.8280339 },
# 						{ lng: -73.9348984, lat: 40.8359569 },
# 						{ lng: -73.9229679, lat: 40.8546564 },
# 						{ lng: -73.9246845, lat: 40.8576427 },
# 						{ lng: -73.9258862, lat: 40.8583567 },
# 						{ lng: -73.9265728, lat: 40.8580322 },
# 						{ lng: -73.9268303, lat: 40.857383 	},
# 						{ lng: -73.9279461, lat: 40.8570584 },
# 						{ lng: -73.9286327, lat: 40.8574479 },
# 						{ lng: -73.9307785, lat: 40.8572532 },
# 						{ lng: -73.9319801, lat: 40.8565391 },
# 						{ lng: -73.9325809, lat: 40.8567338 },
# 						{ lng: -73.9312935, lat: 40.8594603 }]
# washington_heights.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Washington Heights')
# end

# hamilton_heights = [	{ lng: -73.9605618, lat: 40.8223834 },
# 						{ lng: -73.9479017, lat: 40.8171546 },
# 						{ lng: -73.9447689, lat: 40.8240071 },
# 						{ lng: -73.9431381, lat: 40.8261829 },
# 						{ lng: -73.9412928, lat: 40.8309564 },
# 						{ lng: -73.9500904, lat: 40.8346581 },
# 						{ lng: -73.9602184, lat: 40.8229679 },
# 						{ lng: -73.9605618, lat: 40.8223834 }]
# hamilton_heights.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Hamilton Heights')
# end

# morning_side_heights = [{ lng: -73.9709902, lat: 40.8058187 },
# 						{ lng: -73.9597893, lat: 40.8012708 },
# 						{ lng: -73.9580727, lat: 40.8032849 },
# 						{ lng: -73.9583302, lat: 40.8055588 },
# 						{ lng: -73.9551544, lat: 40.8101064 },
# 						{ lng: -73.9579868, lat: 40.8112108 },
# 						{ lng: -73.9562702, lat: 40.8133545 },
# 						{ lng: -73.9598322, lat: 40.8171221 },
# 						{ lng: -73.9623642, lat: 40.8181289 },
# 						{ lng: -73.9709902, lat: 40.8058187 }]
# morning_side_heights.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Morningside Heights')
# end

# hudson_heights = [	{ lng: -73.9388466, lat: 40.844658  },
# 					{ lng: -73.937645,  lat: 40.8483914 },
# 					{ lng: -73.9357567, lat: 40.8500145 },
# 					{ lng: -73.9312935, lat: 40.8594603 },
# 					{ lng: -73.9321947, lat: 40.8595577 },
# 					{ lng: -73.9330101, lat: 40.8582269 },
# 					{ lng: -73.9342976, lat: 40.858584  },
# 					{ lng: -73.9337826, lat: 40.8592656 },
# 					{ lng: -73.9348984, lat: 40.8595252 },
# 					{ lng: -73.9365721, lat: 40.8574155 },
# 					{ lng: -73.937602,  lat: 40.8578699 },
# 					{ lng: -73.9399624, lat: 40.8548836 },
# 					{ lng: -73.9403486, lat: 40.8538774 },
# 					{ lng: -73.9417648, lat: 40.8517999 },
# 					{ lng: -73.9428377, lat: 40.850891 	},
# 					{ lng: -73.9435673, lat: 40.8463786 },
# 					{ lng: -73.9388466, lat: 40.844658  }]
# hudson_heights.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Hudson Heights')
# end

# upper_manhattan = [	{ lng: -73.9434814, lat: 40.783401  },
# 					{ lng: -73.9395332, lat: 40.7858706 },
# 					{ lng: -73.936615, 	lat: 40.7901596 },
# 					{ lng: -73.9436531, lat: 40.7856106 },
# 					{ lng: -73.9302635, lat: 40.7945783 },
# 					{ lng: -73.9290619, lat: 40.7966576 },
# 					{ lng: -73.9304352, lat: 40.8036747 },
# 					{ lng: -73.9347267, lat: 40.8097816 },
# 					{ lng: -73.9348984, lat: 40.8359569 },
# 					{ lng: -73.9229679, lat: 40.8546564 },
# 					{ lng: -73.9138699, lat: 40.8646533 },
# 					{ lng: -73.9108658, lat: 40.869132 	},
# 					{ lng: -73.9103508, lat: 40.8713387 },
# 					{ lng: -73.9113808, lat: 40.8732209 },
# 					{ lng: -73.9142132, lat: 40.874454 	},
# 					{ lng: -73.9185905, lat: 40.8747785 },
# 					{ lng: -73.9226246, lat: 40.8773096 },
# 					{ lng: -73.9264011, lat: 40.8776341 },
# 					{ lng: -73.9284611, lat: 40.8767255 },
# 					{ lng: -73.9322376, lat: 40.871144  },
# 					{ lng: -73.9324093, lat: 40.8693916 },
# 					{ lng: -73.9323235, lat: 40.8674444 },
# 					{ lng: -73.9420223, lat: 40.8535528 },
# 					{ lng: -73.9476871, lat: 40.8507611 },
# 					{ lng: -73.9459705, lat: 40.8444632 },
# 					{ lng: -73.9486313, lat: 40.839918  },
# 					{ lng: -73.9500904, lat: 40.8346581 },
# 					{ lng: -73.9602184, lat: 40.8229679 },
# 					{ lng: -73.9709902, lat: 40.8058187 },
# 					{ lng: -73.9492321, lat: 40.7969175 },
# 					{ lng: -73.9557552, lat: 40.7878852 },
# 					{ lng: -73.9434814, lat: 40.783401 }]
# upper_manhattan.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Upper Manhattan')
# end

# marble_hill = [	{ lng: -73.9086342, lat: 40.8713712 },
# 				{ lng: -73.9068317, lat: 40.8728639 },
# 				{ lng: -73.9067459, lat: 40.8734481 },
# 				{ lng: -73.9072609, lat: 40.8763037 },
# 				{ lng: -73.9093208, lat: 40.8787373 },
# 				{ lng: -73.9112949, lat: 40.8794836 },
# 				{ lng: -73.9121532, lat: 40.8781208 },
# 				{ lng: -73.9149427, lat: 40.8765957 },
# 				{ lng: -73.9152002, lat: 40.8756547 },
# 				{ lng: -73.9106941, lat: 40.8740646 },
# 				{ lng: -73.9086342, lat: 40.8713712 }]
# marble_hill.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Marble Hill')
# end


# # gramercy = [{ lng: -73.9863539, lat: 40.7402339 },
# # 			{ lng: -73.9900017, lat: 40.7351937 },
# # 			{ lng: -73.9899588, lat: 40.7343157 },
# # 			{ lng: -73.9825988, lat: 40.731389 },
# # 			{ lng: -73.9785004, lat: 40.7369172 },
# # 			{ lng: -73.9863539, lat: 40.7402339 }]
# # gramercy.each do |coord|
# # 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Gramercy Park')
# # end

# # battery_park = [{ lng: -74.0166521, lat: 40.7185748 },
# # 				{ lng: -74.0193558, lat: 40.7062461 },
# # 				{ lng: -74.0188408, lat: 40.704717 },
# # 				{ lng: -74.0174675, lat: 40.7045218 },
# # 				{ lng: -74.0163946, lat: 40.7064413 },
# # 				{ lng: -74.0151501, lat: 40.7100848 },
# # 				{ lng: -74.0129185, lat: 40.7183471 },
# # 				{ lng: -74.0166521, lat: 40.7185748 }]
# # battery_park.each do |coord|
# # 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Battery Park City')
# # end


# # tribeca = [ { lng: -74.0109444, lat: 40.7257952 },
# # 			{ lng: -74.0133905, lat: 40.7144438 },
# # 			{ lng: -74.0138197, lat: 40.7136305 },
# # 			{ lng: -74.0091848, lat: 40.7115487 },
# # 			{ lng: -74.0084553, lat: 40.7116137 },
# # 			{ lng: -74.0018463, lat: 40.7194204 },
# # 			{ lng: -74.0109444, lat: 40.7257952 }]
# # tribeca.each do |coord|
# # 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Tribeca')
# # end

# # lower_east_side = [	{ lng: -73.9925766, lat: 40.7242016 },
# # 					{ lng: -73.9958382, lat: 40.7165256 },
# # 					{ lng: -73.99189, 	lat: 40.7092715 },
# # 					{ lng: -73.9890146, lat: 40.709727 },
# # 					{ lng: -73.9887571, lat: 40.7088161 },
# # 					{ lng: -73.9809465, lat: 40.7096294 },
# # 					{ lng: -73.9809895, lat: 40.7099547 },
# # 					{ lng: -73.9778137, lat: 40.7103125 },
# # 					{ lng: -73.9762688, lat: 40.7115161 },
# # 					{ lng: -73.9733076, lat: 40.7185422 },
# # 					{ lng: -73.97717,	lat: 40.7192578 },
# # 					{ lng: -73.978672,	lat: 40.7198758 },
# # 					{ lng: -73.9925766,	lat: 40.7242016 }]
# # lower_east_side.each do |coord|
# # 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Lower East Side')
# # end

# # soho = [{ lng: -74.0018463, lat: 40.7194204 },
# # 		{ lng: -73.9999151, lat: 40.7180543 },
# # 		{ lng: -73.9976406, lat: 40.720819 },
# # 		{ lng: -73.9966536, lat: 40.7233885 },
# # 		{ lng: -73.9953232, lat: 40.7251123 },
# # 		{ lng: -73.9967823, lat: 40.725405 },
# # 		{ lng: -74.0026617, lat: 40.728397 },
# # 		{ lng: -74.0092707, lat: 40.7290149 },
# # 		{ lng: -74.0094852, lat: 40.7278116 },
# # 		{ lng: -74.0150213, lat: 40.7282995 },
# # 		{ lng: -74.0154076, lat: 40.7263481 },
# # 		{ lng: -74.0109444, lat: 40.7257952 },
# # 		{ lng: -74.0018463, lat: 40.7194204 }]
# # soho.each do |coord|
# # 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'SoHo')
# # end
# # stuyvesant_town = [ { lng: -73.9799595, lat: 40.7349661 },
# # 					{ lng: -73.9825988, lat: 40.7313402 },
# # 					{ lng: -73.9757109, lat: 40.7283808 },
# # 					{ lng: -73.973887, lat: 40.7309662 },
# # 					{ lng: -73.974402, lat: 40.7327223 },
# # 					{ lng: -73.9799595, lat: 40.7349661 }]
# # stuyvesant_town.each do |coord|
# # 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Stuyvesant Town')
# # end

# # east_harlem = [ { lng: -73.9414215, lat: 40.7821012 },
# # 				{ lng: -73.9300919, lat: 40.7932787 },
# # 				{ lng: -73.9282036, lat: 40.7966576 },
# # 				{ lng: -73.9292336, lat: 40.8026352 },
# # 				{ lng: -73.9342117, lat: 40.8096517 },
# # 				{ lng: -73.9340401, lat: 40.8184862 },
# # 				{ lng: -73.9551544, lat: 40.78873 },
# # 				{ lng: -73.9414215, lat: 40.7821012 }]
# # east_harlem.each do |coord|
# # 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'East Harlem')
# # end

# # east_harlem_10035 = [	{ lng: -73.9341259, lat: 40.8173819 },
# # 						{ lng: -73.9464855, lat: 40.8004911 },
# # 						{ lng: -73.9313793, lat: 40.7941235 },
# # 						{ lng: -73.93507, 	lat: 40.7919791 },
# # 						{ lng: -73.9372158, lat: 40.7897047 },
# # 						{ lng: -73.9382458, lat: 40.7872353 },
# # 						{ lng: -73.9397907, lat: 40.7857406 },
# # 						{ lng: -73.9368725, lat: 40.7818413 },
# # 						{ lng: -73.931551, 	lat: 40.7819713 },
# # 						{ lng: -73.9278603, lat: 40.7802165 },
# # 						{ lng: -73.9255428, lat: 40.7819713 },
# # 						{ lng: -73.9226246, lat: 40.7831411 },
# # 						{ lng: -73.9215088, lat: 40.7858056 },
# # 						{ lng: -73.9172173, lat: 40.7899647 },
# # 						{ lng: -73.913784, 	lat: 40.7929538 },
# # 						{ lng: -73.9131832, lat: 40.7947733 },
# # 						{ lng: -73.915844, 	lat: 40.7978921 },
# # 						{ lng: -73.9202213, lat: 40.7994515 },
# # 						{ lng: -73.9221096, lat: 40.8021804 },
# # 						{ lng: -73.9273453, lat: 40.8021804 },
# # 						{ lng: -73.9341259, lat: 40.8173819 }]
# # east_harlem_10035.each do |coord|
# # 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], zipcode: '10035')
# # end

# # chinatown = [{ lng: -73.9987779, lat: 40.713533 },
# # 			{ lng: -73.9981556, lat: 40.7137281 },
# # 			{ lng: -73.9976406, lat: 40.7134516 },
# # 			{ lng: -73.9902163, lat: 40.7140534 },
# # 			{ lng: -73.9902377, lat: 40.7146227 },
# # 			{ lng: -73.9897442, lat: 40.7155497 },
# # 			{ lng: -73.9954305, lat: 40.7172412 },
# # 			{ lng: -73.9947653, lat: 40.7184609 },
# # 			{ lng: -73.9964819, lat: 40.7190139 },
# # 			{ lng: -73.9977908, lat: 40.7168183 },
# # 			{ lng: -73.9986062, lat: 40.7170948 },
# # 			{ lng: -74.0018892, lat: 40.7194042 },
# # 			{ lng: -74.004035,  lat: 40.7168834 },
# # 			{ lng: -74.0005803, lat: 40.7152244 },
# # 			{ lng: -74.0004516, lat: 40.7143299 },
# # 			{ lng: -73.9987779, lat: 40.713533}]
# # chinatown.each do |coord|
# # 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Chinatown')
# # end

# # civic_center = [{ lng: -74.0013742, lat: 40.709792  },
# # 				{ lng: -74.0006018, lat: 40.7108981 },
# # 				{ lng: -73.9982629, lat: 40.7132239 },
# # 				{ lng: -73.9987779, lat: 40.713533  },
# # 				{ lng: -74.0004516, lat: 40.7143299 },
# # 				{ lng: -74.0005803, lat: 40.7152244 },
# # 				{ lng: -74.0007734, lat: 40.7153383 },
# # 				{ lng: -73.9999151, lat: 40.7165743 },
# # 				{ lng: -74.0024257, lat: 40.7177291 },
# # 				{ lng: -74.0029407, lat: 40.7171273 },
# # 				{ lng: -74.002769, 	lat: 40.7170297 },
# # 				{ lng: -74.003284, 	lat: 40.7165093 },
# # 				{ lng: -74.004035, 	lat: 40.7168834 },
# # 				{ lng: -74.0086269, lat: 40.7113372 },
# # 				{ lng: -74.0052366, lat: 40.7121017 },
# # 				{ lng: -74.0036917, lat: 40.7114023 },
# # 				{ lng: -74.0013742, lat: 40.709792 }]
# # civic_center.each do |coord|
# # 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Civic Center')
# # end

# # little_italy = [{ lng: -73.9977908, lat: 40.7168183 },
# # 				{ lng: -73.9964819, lat: 40.7190139 },
# # 				{ lng: -73.9947653, lat: 40.7184609 },
# # 				{ lng: -73.994379, 	lat: 40.7194855 },
# # 				{ lng: -73.9998937, lat: 40.721746 	},
# # 				{ lng: -74.0018892, lat: 40.7194042 },
# # 				{ lng: -73.998735, 	lat: 40.7171598 },
# # 				{ lng: -73.9977908, lat: 40.7168183 }]
# # little_italy.each do |coord|
# # 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Little Italy')
# # end

# # nolita = [	{ lng: -73.9981341, lat: 40.7211118 },
# # 			{ lng: -73.994379,  lat: 40.7194855 },
# # 			{ lng: -73.9944649, lat: 40.7193391 },
# # 			{ lng: -73.9933491, lat: 40.7190789 },
# # 			{ lng: -73.9910531, lat: 40.7236487 },
# # 			{ lng: -73.9953661, lat: 40.7250797 },
# # 			{ lng: -73.9967394, lat: 40.7235186 },
# # 			{ lng: -73.9971256, lat: 40.7223315 },
# # 			{ lng: -73.9981341, lat: 40.7211118 }]
# # nolita.each do |coord|
# # 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Nolita')
# # end

# # sp = [  { lng: -73.9620423, lat: 40.7598544 },
# # 		{ lng: -73.9648747, lat: 40.7560023 },
# # 		{ lng: -73.9618921, lat: 40.7547182 },
# # 		{ lng: -73.960433, 	lat: 40.7558235 },
# # 		{ lng: -73.958416, 	lat: 40.7583916 },
# # 		{ lng: -73.9608622, lat: 40.7594968 },
# # 		{ lng: -73.9620423, lat: 40.7598544 }]
# # sp.each do |coord|
# # 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Sutton Place')
# # end

# # uws = [ { lng: -73.9819336, lat: 40.7680617 },
# # 		{ lng: -73.958416,  lat: 40.8004261 },
# # 		{ lng: -73.9728355, lat: 40.8065333 },
# # 		{ lng: -73.9963531, lat: 40.7737819 },
# # 		{ lng: -73.9819336, lat: 40.7680617 }]
# # uws.each do |coord|
# # 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Upper West Side')
# # end

# # ues = [ { lng: -73.9576435, lat: 40.7583103 },
# # 		{ lng: -73.9407349, lat: 40.7756668 },
# # 		{ lng: -73.9426231, lat: 40.7832061 },
# # 		{ lng: -73.9551544, lat: 40.78873 },
# # 		{ lng: -73.9724922, lat: 40.7649414 },
# # 		{ lng: -73.9576435, lat: 40.7583103 }]
# # ues.each do |coord|
# # 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Upper East Side')
# # end

# Building.all.each do |building|
# 	if building.reviews.present? and building.reviews_count.blank?
# 		building.reviews_count = building.reviews.count
# 	else
# 		building.reviews_count = 0
# 	end
# 	building.save
# end

# manhattan_neighborhoods = ['Lower Manhattan', 'Upper Manhattan', 'Midtown']

# manhattan_neighborhoods.each do |hood|
# 	obj = Neighborhood.where(name: hood)
# 	count = Building.buildings_in_neighborhood(hood).count
# 	unless obj.present?
# 		Neighborhood.create(name: hood, buildings_count: count, boroughs: 'MANHATTAN')
# 	else
# 		obj.first.update(buildings_count: count) if obj.first.buildings_count.to_i != count.to_i
# 	end
# end

# all_neighborhoods = Building.all.map(&:neighborhood).uniq
# pop_neighborhoods = Neighborhood.all.map(&:name).uniq
# new_hoods = all_neighborhoods - pop_neighborhoods

# new_hoods.each do |hood|
# 	buildings = Building.where(neighborhood: hood)
# 	Neighborhood.create(name: hood, buildings_count: buildings.count, boroughs: buildings.first.city) if buildings.present?
# end

# file = File.read("#{Rails.root}/public/subway_stations.geojson")
# data_hash = JSON.parse(file)
# data_hash['features'].each do |feature|
# 	st_name = feature['properties']['name']
# 	line = feature['properties']['line']
# 	lat = feature['geometry']['coordinates'][1]
# 	lng = feature['geometry']['coordinates'][0]
# 	station = SubwayStation.create({ name: st_name, latitude: lat, longitude: lng })
# 	lines = line.split('-')
# 	lines.map do |line|
# 		SubwayStationLine.create(subway_station_id: station.id, line: line, color: station.line_color(line)) unless line.include?('Express')
# 	end
# end
# Building.all.each do |building|
# 	rating_cache = RatingCache.where(cacheable_id: building.id, dimension: 'building')
# 	building.update(avg_rating: rating_cache.first.avg) if rating_cache.present?
# end

#BrokerFeePercent.create(percent_amount: 10)

# neighs = [
#       'New York',
#       'Midtown', 
#       'Sutton Place', 
#       'Upper East Side', 
#       'Yorkville', 
#       'Bowery', 
#       'East Village', 
#       'Financial District',
#       'Lower East Side',
#       'Greenwich Village',
#       'West Village',
#       'Lower Manhattan',
#       'Soho',
#       'Tribeca',
#       'Battery Park City',
#       'Chelsea',
#       'Gramercy Park',
#       'Kips Bay', 
#       "Hell's Kitchen",
#       'Midtown East',
#       'Murray Hill', 
#       'Roosevelt Island',
#       'Carnegie Hill',
#       'Lenox Hill',
#       'Upper West Side',
#       'Lincoln Square',
#       'Upper Manhattan',
#       'East Harlem',
#       'Harlem',
#       'Hudson Heights',
#       'Morningside Heights',
#       'Washington Heights',
#       'Little Italy',
#       'Chinatown',
#       'Inwood',
#       'Hamilton Heights',
#       'Civic Center',
#       'Stuyvesant Town',
#       'Nolita',
#       'Turtle Bay'
#     ]

# Gcoordinate.where(neighborhood: neighs).delete_all

# Building.all.each do |b|
# 	b.update(recommended_percent: b.suggested_percent)
# end




