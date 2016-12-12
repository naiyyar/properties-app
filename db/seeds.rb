# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# user = User.find(2)
# user.add_role :admin

Gcoordinate.where(neighborhood: ['Gramercy','Battery Park']).destroy_all


gramercy = [{ lng: -73.9863539, lat: 40.7402339 },
			{ lng: -73.9900017, lat: 40.7351937 },
			{ lng: -73.9899588, lat: 40.7343157 },
			{ lng: -73.9825988, lat: 40.731389 },
			{ lng: -73.9785004, lat: 40.7369172 },
			{ lng: -73.9863539, lat: 40.7402339 }]
gramercy.each do |coord|
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Gramercy Park')
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
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Battery Park City')
end


tribeca = [ { lng: -74.0109444, lat: 40.7257952 },
			{ lng: -74.0133905, lat: 40.7144438 },
			{ lng: -74.0138197, lat: 40.7136305 },
			{ lng: -74.0091848, lat: 40.7115487 },
			{ lng: -74.0084553, lat: 40.7116137 },
			{ lng: -74.0018463, lat: 40.7194204 },
			{ lng: -74.0109444, lat: 40.7257952 }]
tribeca.each do |coord|
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Tribeca')
end

lower_east_side = [	{ lng: -73.9925766, lat: 40.7242016 },
					{ lng: -73.9958382, lat: 40.7165256 },
					{ lng: -73.99189, 	lat: 40.7092715 },
					{ lng: -73.9890146, lat: 40.709727 },
					{ lng: -73.9887571, lat: 40.7088161 },
					{ lng: -73.9809465, lat: 40.7096294 },
					{ lng: -73.9809895, lat: 40.7099547 },
					{ lng: -73.9778137, lat: 40.7103125 },
					{ lng: -73.9762688, lat: 40.7115161 },
					{ lng: -73.9733076, lat: 40.7185422 },
					{ lng: -73.97717,	lat: 40.7192578 },
					{ lng: -73.978672,	lat: 40.7198758 },
					{ lng: -73.9925766,	lat: 40.7242016 }]
lower_east_side.each do |coord|
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Lower East Side')
end

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
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Soho')
end
