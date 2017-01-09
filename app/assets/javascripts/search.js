brooklyn_neighborhoods = [
				{ key: 'Borough Park', 	url: 'https://www.dropbox.com/s/9o3c7fb2wb9je05/borough_park.kml?dl=1' },
				{ key: 'Canarsie', 			url: 'https://www.dropbox.com/s/24qjmce32do2tsv/canarsie.kml?dl=1' },
				{ key: 'Flatlands', 		url: 'https://www.dropbox.com/s/dxwxqmhl84ohh4b/flatlands.kml?dl=1' },
				{ key: 'Flatbush', 			url: 'https://www.dropbox.com/s/9oibl4vu84i0ii3/flatbush.kml?dl=1' },
				{ key: 'East New York', url: 'https://www.dropbox.com/s/5e4rn3l3q9m7ytl/east_new_york.kml?dl=1' },
				{ key: 'New Lots', 			url: 'new_lots' },
				{ key: 'Greenpoint', 		url: 'https://www.dropbox.com/s/l79tn9hop06dmj9/greenpoint.kml?dl=1' },
				{ key: 'Sunset Park', 	url: 'https://www.dropbox.com/s/5zx4kv6c7reuxk6/sunset_park.kml?dl=1' },
				{ key: 'Bushwick', 			url: 'https://www.dropbox.com/s/r718lxo11kwvcrq/bushwick.kml?dl=1' },
				{ key: 'Williamsburg', 	url: 'https://www.dropbox.com/s/atsw0m2qy3pzoee/williamsburg.kml?dl=1' } 
]

function brookly_boundaries(term){
	
	var url = '';

	$.each( brooklyn_neighborhoods, function(index, value ) {
	  if(term == value.key){
			url = value.url;
		}
	});
	
	add_kml(url)
}

function add_kml(url){
	var kmls = handler.addKml(
			{ url: url }
		);
}