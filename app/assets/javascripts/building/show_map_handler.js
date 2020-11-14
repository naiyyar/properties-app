// functionality for map manipulation icon on mobile devices
var listMapView = function(){
  if ($('#mapView').hasClass('mob-min') || 
      $('#mapView').hasClass('mob-max') || 
      $('#content').hasClass('mob-min') || 
      $('#content').hasClass('mob-max')) {
      $('#mapView').toggleClass('mob-max');
      $('#content').toggleClass('mob-min');
  } else {
      $('#content').toggleClass('min');
      $('#mapView').toggleClass('max');
  }
  MapObject.initialize();
}

$('.listHandler').click(function(){
  $(this).hide();
  $('.mapHandler').show();
  listMapView();
})

$('.show-map-handler').click(function() {
  if(!$(this).hasClass('show-map-handler')){
    $(this).hide();
  }
  $('.listHandler').show();
  listMapView();
});

// calculations for elements that changes size on window resize
var showWindowResizeHandler = function(map) {
  windowHeight = window.innerHeight;
  windowWidth = $(window).width();
  contentHeight = windowHeight - $('#header').height();
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
function loadMarkerWindow(building_id, map, marker){
  $.post('/load_infobox', {
    object_id: building_id, 
    building_show: false,
    current_user_id: current_user_id,
  }, function(data){
    infobox.setContent(data.html);
    infobox.open(map, marker);
  });
}