function createSidebarElem(json){
  title = json.marker_title.split(',');
  building_name = title[1];
  address = title[2];
  city = title[3];
  state = title[4];
  zipcode = title[5];

  if(building_name == ' '){
    building_name = address
  }
  return ("<h2>" + building_name + "</h2>" +
  					"<div class='cardAddress'><span class='icon-location-pin'></span>"+ address+','+city+','+state+' '+zipcode +"</div>"
          );
};

function bindElemToMarker(elem, marker){
  elem.on('mouseover', function(){
    marker.serviceObject.setIcon("/assets/green-dot-5e6775e65a5ce15a392cf5589aeec9d9940918b36837324d62394c281bbc8851.png");
  }).on('mouseout', function(){
    marker.serviceObject.setIcon("/assets/red-dot-6e85e9db33319a2df8e8c233d830282ce3c7795dd1d27841fffc7288622548d3.png")
  })
};

function bindMarker(marker, markers, handler, lat, lng, zoom){
  $(window).on('load', function(){
    marker.serviceObject.setIcon("http://maps.google.com/mapfiles/ms/icons/red-dot.png")
    marker.setMap(handler.getMap());
    marker.panTo();
    google.maps.event.trigger(marker.getServiceObject(), 'load');
    handler.bounds.extendWith(markers);
    handler.fitMapToBounds();
    handler.getMap().setZoom(zoom);
    //handler.map.centerOn(markers[0]);
  })
};

function createSidebar(json_array){
  _.each(json_array, function(json){
    var elem = $( createSidebarElem(json) );
    var id = json.marker_title.split(',')[0]
    elem.appendTo('#building_details'+id);
    bindElemToMarker(elem, json.marker);
  });
};
