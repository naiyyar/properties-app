// Bedford-Stuyvesant
// Williamsburg
// Bushwick
// Crown Heights
// Park Slope
// Greenpoint
// Flatbush
// Clinton Hill
// Downtown Brooklyn
// Prospect Lefferts Gardens
// Brooklyn Heights
// Fort Greene
// Bay Ridge
// Prospect Heights
// Carroll Gardens
// Northeast Flatbush
// Sheepshead Bay
// Ditmas Park
// Boerum Hill
// DUMBO
// Kensington
// Cobble Hill
// Sunset Park
// Prospect Park South
// Windsor Terrace
// Gowanus
// Greenwood
// Midwood
var brooklyn_and_queens_neighborhoods_hash = [
	{ key: 'Borough Park', 				url: 'https://www.dropbox.com/s/9o3c7fb2wb9je05/borough_park.kml?dl=1' },
	{ key: 'Canarsie', 					url: 'https://www.dropbox.com/s/24qjmce32do2tsv/canarsie.kml?dl=1' },
	{ key: 'Flatlands', 				url: 'https://www.dropbox.com/s/dxwxqmhl84ohh4b/flatlands.kml?dl=1' },
	{ key: 'Flatbush', 					url: 'https://www.dropbox.com/s/9oibl4vu84i0ii3/flatbush.kml?dl=1' },
	{ key: 'East New York', 			url: 'https://www.dropbox.com/s/5e4rn3l3q9m7ytl/east_new_york.kml?dl=1' },
	{ key: 'Greenpoint', 				url: 'https://www.dropbox.com/s/l79tn9hop06dmj9/greenpoint.kml?dl=1' },
	{ key: 'Sunset Park', 				url: 'https://www.dropbox.com/s/5zx4kv6c7reuxk6/sunset_park.kml?dl=1' },
	{ key: 'Bushwick', 					url: 'https://www.dropbox.com/s/r718lxo11kwvcrq/bushwick.kml?dl=1' },
	{ key: 'Williamsburg', 				url: 'https://www.dropbox.com/s/atsw0m2qy3pzoee/williamsburg.kml?dl=1' },
	{ key: 'Jamaica', 					url: 'https://www.dropbox.com/s/3373jfu47j4rga0/jamica.kml?dl=1'},
	{ key: 'Rockaways', 				url: 'https://www.dropbox.com/s/du5ztuzpdvt3td3/rockaways.kml?dl=1'},
	{ key: 'Bedford-Stuyvesant', 		url: 'https://www.dropbox.com/s/yabx4ou89sowaas/bedford.kml?dl=1'},
	{ key: 'Crown Heights', 			url: 'https://www.dropbox.com/s/nmrstsu0tp0iqgu/crown_heights.kml?dl=1'},
	{ key: 'Park Slope', 				url: 'https://www.dropbox.com/s/0uafwf7ujlmp44f/slop_park.kml?dl=1'},
	{ key: 'Clinton Hill', 				url: 'https://www.dropbox.com/s/tz24xupay3c7vq3/clinton_hill.kml?dl=1'},
	{ key: 'Downtown Brooklyn', 		url: 'https://www.dropbox.com/s/hzb90d5jow1abn1/downtown_brooklyn.kml?dl=1'},
	{ key: 'Prospect Lefferts Gardens', url: 'https://www.dropbox.com/s/edlvf5wkfbktrsf/plg.kml?dl=1'},
	{ key: 'Brooklyn Heights', 			url: 'https://www.dropbox.com/s/k4hbsi9dqyakazh/brooklyn_heights.kml?dl=1'},
	{ key: 'Fort Greene', 				url: 'https://www.dropbox.com/s/jumhu5tnhodi2a3/fort_greene.kml?dl=1'},
	{ key: 'Bay Ridge', 				url: 'https://www.dropbox.com/s/apsrfhkj49swmzr/bay_ridge.kml?dl=1'},
	{ key: 'Prospect Heights', 			url: 'https://www.dropbox.com/s/w5zopnbicxxqfw5/prospect_heights.kml?dl=1'},
	{ key: 'Carroll Gardens', 			url: 'https://www.dropbox.com/s/yzvl791yenn775l/carroll_garden.kml?dl=1'},
	{ key: 'Northeast Flatbush', 		url: ''},
	{ key: 'Sheepshead Bay', 			url: 'https://www.dropbox.com/s/2x2g74finfk80rt/sheepshead_bay.kml?dl=1'},
	{ key: 'Flatbush - Ditmas Park', 	url: 'https://www.dropbox.com/s/9oibl4vu84i0ii3/flatbush.kml?dl=1'},
	{ key: 'Ditmas Park', 				url: 'https://www.dropbox.com/s/9oibl4vu84i0ii3/flatbush.kml?dl=1'},
	{ key: 'Boerum Hill',				url: 'https://www.dropbox.com/s/fw16uqqq6o8p7rs/boerum_hill.kml?dl=1'},
	{ key: 'DUMBO',						url: 'https://www.dropbox.com/s/7kj2o86de5fqfo6/dumbo.kml?dl=1'},
	{ key: 'Dumbo',						url: 'https://www.dropbox.com/s/7kj2o86de5fqfo6/dumbo.kml?dl=1'},
	{ key: 'Kensington',				url: 'https://www.dropbox.com/s/0y3slszi1axvhus/kensington.kml?dl=1'},
	{ key: 'Cobble Hill',				url: 'https://www.dropbox.com/s/lwbev5agq4ktnad/cobble_hill.kml?dl=1'},
	{ key: 'Prospect Park South',		url: 'https://www.dropbox.com/s/beauiveb6nzotsr/prospect_park_south.kml?dl=1'},
	{ key: 'Windsor Terrace',			url: 'https://www.dropbox.com/s/xvzeul9ezvtidud/windsor_terrace.kml?dl=1'},
	{ key: 'Gowanus',					url: 'https://www.dropbox.com/s/bxscyssry09uf55/gowanus.kml?dl=1'},
	{ key: 'Greenwood',					url: 'https://www.dropbox.com/s/j0a0isws8f4br8i/greenwood.kml?dl=1'},
	{ key: 'Midwood', 					url: 'https://www.dropbox.com/s/uz21mxzlpxd9mhq/midwood.kml?dl=1'},
	{ key: 'Astoria', 					url: 'https://www.dropbox.com/s/byecxgngp60stis/astoria.kml?dl=1'},
	{ key: 'Long Island City', 			url: 'https://www.dropbox.com/s/lqcj3gzdb17ddrk/long_island_city.kml?dl=1'},
	{ key: 'Forest Hills', 				url: 'https://www.dropbox.com/s/4f6qatuh7c7lnje/forest_hill.kml?dl=1'},
	{ key: 'Sunnyside', 				url: 'https://www.dropbox.com/s/hi5h07h5rt0y2i8/sunnyside.kml?dl=1'},
	{ key: 'Ridgewood', 				url: 'https://www.dropbox.com/s/5ij98le5k6hzy6n/ridgewood.kml?dl=1'},
	{ key: 'Rego Park', 				url: 'https://www.dropbox.com/s/440gzk0gt644n08/rego_park.kml?dl=1'},
	{ key: 'Kew Gardens', 				url: 'https://www.dropbox.com/s/ki7k9ht6x37ut7i/kew_garden.kml?dl=1'},
	{ key: 'Flushing', 					url: 'https://www.dropbox.com/s/cqh4slnzbeq03dw/flushing.kml?dl=1'},
	{ key: 'Woodside', 					url: 'https://www.dropbox.com/s/ohflj1urwh92w44/woodside.kml?dl=1'},
	{ key: 'Jackson Heights', 			url: 'https://www.dropbox.com/s/7r1wbb8e0ud65mp/jackson_heights.kml?dl=1'},
	{ key: 'Elmhurst', 					url: 'https://www.dropbox.com/s/byecxgngp60stis/astoria.kml?dl=1'}
]

function brooklyn_and_queens_neighborhoods(term){
	
	var url = '';
	
	$.each(brooklyn_and_queens_neighborhoods_hash, function(index, value ) {
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