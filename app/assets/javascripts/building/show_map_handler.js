// functionality for map manipulation icon on mobile devices
var showListMapView = function(){
  if ($('#mapView').hasClass('mob-min') || 
      $('#mapView').hasClass('mob-max') || 
      $('#content').hasClass('mob-min') || 
      $('#content').hasClass('mob-max')) {
      $('#mapView').toggleClass('mob-max mob-min');
      $('#content').toggleClass('mob-min mob-max');
  } else {
      $('#content').toggleClass('min');
      $('#mapView').toggleClass('max');
  }
  MapObject.initialize();
}

$('.listHandler').click(function(){
  $(this).hide();
  $('.mapHandler').show();
  showListMapView();
})

$('.show-map-handler').click(function() {
  if(!$(this).hasClass('show-map-handler')){
    $(this).hide();
  }
  $('.listHandler').show();
  showListMapView();
});

// calculations for elements that changes size on window resize
var showWindowResizeHandler = function(map) {
  windowHeight = window.innerHeight;
  windowWidth = $(window).width();
  contentHeight = windowHeight - $('.HeaderBlock, #header-mob').height();
  contentWidth = $('#content').width();
  $('#leftSide').height(contentHeight);
  $('.closeLeftSide').height(contentHeight);
  $('#wrapper').height(contentHeight);
  $('#mapView').height(contentHeight);
  if(map){
    google.maps.event.trigger(map, 'resize');
  }
}

//
function loadShowMarkerWindow(prop_id, map, marker){
  $.post('/load_infobox', {
    object_id: prop_id, 
    building_show: false,
    current_user_id: current_user_id,
    property_type: current_object_type
  }, function(data){
    infobox.setContent(data.html);
    infobox.open(map, marker);
  });
}