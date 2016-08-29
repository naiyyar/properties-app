function createSidebarLi(json){
  title = json.marker_title.split(',')
  building_name = title[1]
  address = title[2]
  return ("<h4 class='list-group-item-heading'>" + building_name + "</h4>" +
  					"<p class='list-group-item-text'>"+ address +"</p>"
          );
};

function bindLiToMarker(elem, marker){
  elem.on('click', function(){
    handler.getMap().setZoom(15);
    marker.setMap(handler.getMap()); //because clusterer removes map property from marker
    marker.panTo();
    google.maps.event.trigger(marker.getServiceObject(), 'click');
  })
};

function bindMarker(marker){
  $(window).on('load', function(){
    handler.getMap().setZoom(11);
    marker.setMap(handler.getMap());
    marker.panTo();
    google.maps.event.trigger(marker.getServiceObject(), 'load');
  })
};

function createSidebar(json_array){
  _.each(json_array, function(json){
    var $li = $( createSidebarLi(json) );
    id = json.marker_title.split(',')[0]
    $li.appendTo('#apt_sidebar_container'+id);
    bindLiToMarker($li, json.marker);
  });
};