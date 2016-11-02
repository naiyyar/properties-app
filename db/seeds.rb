# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# user = User.find(2)
# user.add_role :admin

# coords_midtown_manhattan = [{ lat: 40.772885, lng: -73.993642 },
# 														{ lat: 40.742447, lng: -74.008984 },
# 														{ lat: 40.726891, lng: -73.971881 },
# 														{ lat: 40.758343, lng: -73.958909 }]

# coords_midtown_manhattan.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Midtown Manhattan')
# end

# coords_midtown_east = [ { lat: 40.753494, lng: -73.980858 },
# 												{ lat: 40.764173, lng: -73.973112 },
# 												{ lat: 40.758391, lng: -73.959106 },
# 												{ lat: 40.748166, lng: -73.968096 }]

# coords_midtown_east.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Midtown East')
# end

# coords_kips_bay = [ { lat: 40.746376, lng: -73.979737 },
# 										{ lat: 40.742979, lng: -73.971755 },
# 										{ lat: 40.739500, lng: -73.984736 },
# 										{ lat: 40.734931, lng: -73.973428 }]

# coords_kips_bay.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Kips Bay')
# end

# coords_murray_hill = [{lat: 40.743761, lng: -73.973522 },
# 											{lat: 40.747777, lng: -73.982921 },
# 											{lat: 40.748793, lng: -73.969883 },
# 											{lat: 40.752810, lng: -73.979289 }]

# coords_murray_hill.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Murray Hill')
# end

# coords_sutton_place = [{ lat: 40.758385, lng: -73.971005 },
# 											 { lat: 40.762213, lng: -73.968183 },
# 											 { lat: 40.758347, lng: -73.958982 }, 
# 											 { lat: 40.758347, lng: -73.958982 }]

# coords_sutton_place.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Sutton Place')
# end

# coords_turtle_bay = [ { lat: 40.751487, lng: -73.976041 },
# 											{ lat: 40.748114, lng: -73.968220 },
# 											{ lat: 40.754754, lng: -73.962223 },
# 											{ lat: 40.758370, lng: -73.971010 }]

# coords_turtle_bay.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Turtle Bay')
# end

# coords_midtown_north = [{ lat: 40.757208, lng: -73.989783 },
# 												{ lat: 40.751474, lng: -73.976142 },
# 												{ lat: 40.762226, lng: -73.968203 },
# 												{ lat: 40.768060, lng: -73.981925 }]

# coords_midtown_north.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Midtown North')
# end

# coords_midtown_south = [{ lat: 40.749669, lng: -73.995295 },
# 												{ lat: 40.743857, lng: -73.981584 },
# 												{ lat: 40.751416, lng: -73.976144 },
# 												{ lat: 40.757194, lng: -73.989791 }]

# coords_midtown_south.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Midtown South')
# end

# coords_midtown_west = [ { lat: 40.757151, lng: -74.004719 },
# 												{ lat: 40.772798, lng: -73.993723 },
# 												{ lat: 40.767435, lng: -73.982479 },
# 												{ lat: 40.752230, lng: -73.993486 }]

# coords_midtown_west.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Midtown West')
# end

Gcoordinate.where(neighborhood: 'Hells Kitchen').destroy_all
coords_hells_kitchen = [{ lat: 40.772765, lng: -73.993680 },
												{ lat: 40.761440, lng: -74.001876 },
												{ lat: 40.756588, lng: -73.990289 },
												{ lat: 40.767447, lng: -73.982438 }]

coords_hells_kitchen.each do |coord|
	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: "Hell's Kitchen")
end

# coords_hudson_yard = [{ lat: 40.754417, lng: -74.006641 },
# 											{ lat: 40.749662, lng: -73.995333 },
# 											{ lat: 40.756578, lng: -73.990280 },
# 											{ lat: 40.761332, lng: -74.001599 }]

# coords_hudson_yard.each do |coord|
# 	Gcoordinate.create(latitude: coord[:lat], longitude: coord[:lng], neighborhood: 'Hudson Yards')
# end

