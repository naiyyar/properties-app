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
	{ key: 'East Flatbush', 			url: 'https://www.dropbox.com/s/9oibl4vu84i0ii3/flatbush.kml?dl=1'},
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

var brooklyn_and_queens_zipcodes_hash = [
	{ key: '11201', 				url: 'https://www.dropbox.com/s/4434yaaw95q6gzv/11201.kml?dl=1' },
	{ key: '11203', 				url: 'https://www.dropbox.com/s/lcr8083wijr2wrz/11203.kml?dl=1' },
	{ key: '11204', 				url: 'https://www.dropbox.com/s/snq1imf6a74371k/11204.kml?dl=1' },
	{ key: '11205', 				url: 'https://www.dropbox.com/s/9lryk7mwz7ckdsq/11205.kml?dl=1' },
	{ key: '11206', 				url: 'https://www.dropbox.com/s/ivcg7j6mteoso9y/11206.kml?dl=1' },
	{ key: '11207', 				url: 'https://www.dropbox.com/s/lsgo5sh8njjggwu/11207.kml?dl=1' },
	{ key: '11208', 				url: 'https://www.dropbox.com/s/kc23hcwojnlenee/11208.kml?dl=1' },
	{ key: '11209', 				url: 'https://www.dropbox.com/s/231lux1n1471kg1/11209.kml?dl=1' },
	{ key: '11210', 				url: 'https://www.dropbox.com/s/wyt2octs86m62si/11210.kml?dl=1' },
	{ key: '11211', 				url: 'https://www.dropbox.com/s/1zgodcz0nxoww7c/11211.kml?dl=1'	},
	{ key: '11212', 				url: 'https://www.dropbox.com/s/qcl3mg3bowztze0/11212.kml?dl=1' },
	{ key: '11213', 				url: 'https://www.dropbox.com/s/1w6xwfkv8f63zv2/11213.kml?dl=1'	},
	{ key: '11214', 				url: 'https://www.dropbox.com/s/ag8f38kjbs13i6b/11214.kml?dl=1'	},
	{ key: '11215', 				url: 'https://www.dropbox.com/s/gd4aqwcjch817mu/11215.kml?dl=1'	},
	{ key: '11216', 				url: 'https://www.dropbox.com/s/ysosu0o9hl3at7c/11216.kml?dl=1'	},
	{ key: '11217', 				url: 'https://www.dropbox.com/s/whkctpufwo7d0p5/11217.kml?dl=1'	},
	{ key: '11218', 				url: 'https://www.dropbox.com/s/z016mrv9e1plf0s/11218.kml?dl=1'	},
	{ key: '11219', 				url: 'https://www.dropbox.com/s/dpwrkspi19old16/11219.kml?dl=1' },
	{ key: '11220', 				url: 'https://www.dropbox.com/s/05ng05xxe6vf1ad/11220.kml?dl=1' },
	{ key: '11221', 				url: 'https://www.dropbox.com/s/m0ie2kg05ef1k9a/11221.kml?dl=1' },
	{ key: '11222', 				url: 'https://www.dropbox.com/s/9rd11tcldlrre4c/11222.kml?dl=1' },
	{ key: '11223', 				url: 'https://www.dropbox.com/s/1510tq3ue209o3z/11223.kml?dl=1' },
	{ key: '11224', 				url: 'https://www.dropbox.com/s/crxvvl02ikk5gyv/11224.kml?dl=1' },
	{ key: '11225', 				url: 'https://www.dropbox.com/s/pa9bsjsd4zypvyo/11225.kml?dl=1' },
	{ key: '11226', 				url: 'https://www.dropbox.com/s/6xgx51n40wb2t6f/11226.kml?dl=1' },
	{ key: '11228',					url: 'https://www.dropbox.com/s/hwdl9oi5zcoztfb/11228.kml?dl=1' },
	{ key: '11229',					url: 'https://www.dropbox.com/s/hkiei8k4vtta4bz/11229.kml?dl=1' },
	{ key: '11230',					url: 'https://www.dropbox.com/s/ybjtydgcy051714/11230.kml?dl=1' },
	{ key: '11231',					url: 'https://www.dropbox.com/s/zywfck8g3gy48zi/11231.kml?dl=1'	},
	{ key: '11232',					url: 'https://www.dropbox.com/s/3kh84wk211jrdlv/11232.kml?dl=1'	},
	{ key: '11233',					url: 'https://www.dropbox.com/s/kbsnunk43o2ci1b/11233.kml?dl=1' },
	{ key: '11234',					url: 'https://www.dropbox.com/s/ictey2o5j4mcivs/11234.kml?dl=1' },
	{ key: '11235',					url: 'https://www.dropbox.com/s/9r93ljvee47j6to/11235.kml?dl=1' },
	{ key: '11236',					url: 'https://www.dropbox.com/s/2jhadp0natetv55/11236.kml?dl=1' },
	{ key: '11237', 				url: 'https://www.dropbox.com/s/oerqe1l5w67xm2u/11237.kml?dl=1' },
	{ key: '11238', 				url: 'https://www.dropbox.com/s/bj3eyvfzxfe8ljj/11238.kml?dl=1' },
	{ key: '11239', 				url: 'https://www.dropbox.com/s/ykc8m9m74pllq0n/11239.kml?dl=1' }
]


function brooklyn_and_queens_neighborhoods(term){
	
	url = '';
	
	$.each(brooklyn_and_queens_neighborhoods_hash, function(index, value ) {
	  if(term == value.key){
			url = value.url;
		}
	});
	
	if(url==''){
		term = term.split(' - ')[0]
		$.each(brooklyn_and_queens_zipcodes_hash, function(index, value ) {
		  if(term == value.key){
				url = value.url;
			}
		});
	}
	
	add_kml(url)
}

function add_kml(url){
	var kmls = handler.addKml(
			{ url: url }
		);
}