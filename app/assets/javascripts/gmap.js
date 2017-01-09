function createSidebarElem(json){
  title = json.marker_title.split(',');
  building_name = title[1];
  address = title[2];
  zipcode = title[3];
  return ("<h4 class='list-group-item-heading'>" + building_name + "</h4>" +
  					"<p class='list-group-item-text'>"+ address +', '+zipcode+"</p>"
          );
};

function bindElemToMarker(elem, marker){
  elem.on('mouseover', function(){
    //handler.getMap().setZoom(15);
    marker.serviceObject.setIcon("http://maps.google.com/mapfiles/ms/icons/green-dot.png");
    //marker.setMap(handler.getMap()); //because clusterer removes map property from marker
    //marker.panTo();
    //google.maps.event.trigger(marker.getServiceObject(), 'click');
  }).on('mouseout', function(){
    marker.serviceObject.setIcon("http://maps.google.com/mapfiles/ms/icons/red-dot.png")
  })
};

function bindMarker(marker, markers, handler, lat, lng, zoom){
  $(window).on('load', function(){
    marker.serviceObject.setIcon("http://maps.google.com/mapfiles/ms/icons/red-dot.png")
    marker.setMap(handler.getMap());
    marker.panTo();
    google.maps.event.trigger(marker.getServiceObject(), 'load');
    handler.bounds.extendWith(markers);
    //handler.fitMapToBounds();
    handler.getMap().setZoom(zoom);
    handler.map.centerOn(marker);
  })
};

function createSidebar(json_array){
  _.each(json_array, function(json){
    var elem = $( createSidebarElem(json) );
    var id = json.marker_title.split(',')[0]
    elem.appendTo('#apt_sidebar_container'+id);
    bindElemToMarker(elem, json.marker);
  });
};