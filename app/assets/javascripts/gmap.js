function createSidebarLi(json){
  //return ("<li class='list-group-item'><a>" + json.marker_title + "</a></li>");
  title = json.marker_title.split(',')
  window.data = json_array
  building_name = title[0]
  address = title[1]
  return ("<a href='#' class='list-group-item'>" +
  					"<h4 class='list-group-item-heading'>" + building_name + "</h4>" +
  					"<p class='list-group-item-text'>"+ address +"</p>" +
  				"</a>");
};

function bindLiToMarker($li, marker){
  $li.on('click', function(){
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
    $li.appendTo('#apt_sidebar_container');
    bindLiToMarker($li, json.marker);
  });
};