function displayMap(hash){
	handler = Gmaps.build('Google');
	handler.buildMap({ provider: {}, internal: { id: 'mapView' } }, function(){
	    markers = handler.addMarkers(hash);
	    handler.bounds.extendWith(markers);
	    handler.fitMapToBounds();
	    handler.getMap().setZoom(14);
	});
	//google.maps.event.trigger(handler, 'load');
}
