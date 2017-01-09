// Borough Park
// Canarsie
// Flatlands
// Flatbush
// East New York
// New Lots
// Greenpoint
// Sunset Park
// Bushwick 
// Williamsburg

url_hash = {
	sunset_park: "https://www.dropbox.com/s/5zx4kv6c7reuxk6/sunset_park.kml?dl=1",
	borough_park: "https://www.dropbox.com/s/9o3c7fb2wb9je05/borough_park.kml?dl=1",
	greenpoint: "https://www.dropbox.com/s/l79tn9hop06dmj9/greenpoint.kml?dl=1",
	east_new_york: 'https://www.dropbox.com/s/5e4rn3l3q9m7ytl/east_new_york.kml?dl=1',
	canarsie: 'https://www.dropbox.com/s/24qjmce32do2tsv/canarsie.kml?dl=1',
	flatbush: 'https://www.dropbox.com/s/9oibl4vu84i0ii3/flatbush.kml?dl=1',
	flatlands: 'https://www.dropbox.com/s/dxwxqmhl84ohh4b/flatlands.kml?dl=1',
	williamsburg: 'https://www.dropbox.com/s/atsw0m2qy3pzoee/williamsburg.kml?dl=1',
	bushwick: 'https://www.dropbox.com/s/r718lxo11kwvcrq/bushwick.kml?dl=1'
}

function brookly_boundaries(term){
	var url = ''
	if(term == 'Sunset Park'){
		url = url_hash['sunset_park']
	}
	else if(term == 'Borough Park'){
		url = url_hash['borough_park']
	}	
	else if(term == 'Greenpoint'){
		url = url_hash['greenpoint']
	}	
	else if(term == 'Bushwick'){
		url = url_hash['bushwick']
	}	
	else if(term == 'East New York'){
		url = url_hash['east_new_york']
	}	
	else if(term == 'Williamsburg'){
		url = url_hash['williamsburg']
	}	
	else if(term == 'Flatlands'){
		url = url_hash['flatlands']
	}	
	else if(term == 'Flatbush'){
		url = url_hash['flatbush']
	}	
	add_kml(url)
}

function add_kml(url){
	var kmls = handler.addKml(
			{ url: url }
		);
}