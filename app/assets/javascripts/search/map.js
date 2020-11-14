var ready = function(){
  var position;
  var currentLocation;
  var props;
  var bounds;
  var newMarker;
  var markers;
  var options;
  var controlUI;
  var controlText;
  var centerControlDiv;
  var centerControl;
  var json_array    = $('#json-hash').data('buildingshash');
  var zoom          = parseInt($('.zoom').val());
  var zoomLevel     = zoom;
  redo_search       = false;
  var dragged       = false;
  var draggedOnce   = false;
  var lat           = $('#lat').data('lat');
  var lng           = $('#lng').data('lng');
  var serched_by    = $('#searched_by').val();
  var searched_term = $('#search_term').val();
  var search_string = $('#search_string').val();
  var city          = '';
  var header_id     = $('#app-header').length > 0 ? 'app-header' : 'header-mob';
  current_user_id   = $('#cu').val();
  var per_page_buildings  = [];
  var boundary_coords = $('#boundary_coords').data('coords');

  if(searched_term){
    searched_term = search_string;
    if(searched_term != null && searched_term == 'Little Italy'){
      var city = searched_term.includes('newyork') ? 'New York' : 'Bronx'
    }

    infobox = new InfoBubble({
      minWidth: 236,
      maxWidth: 250,
      position: new google.maps.LatLng(lng, lat),
      shadowStyle: 3,
      padding: 0,
      backgroundColor: 'rgb(255,255,255)',
      borderRadius: 2,
      arrowSize: 10,
      borderWidth: 0,
      borderColor: '#2c2c2c',
      disableAutoPan: true,
      hideCloseButton: false
    });
  }

  // Custom options for map
  window.initialize = function(sidebar = true) {
    position  = google.maps.ControlPosition.TOP_CENTER;
    var zoom_ctrl = true;
    if(mobile){
      position  = google.maps.ControlPosition.TOP_LEFT;
      zoom_ctrl = false;
    }
    if(!sidebar){
      // To fix redo button on mobile when switching between map and list view
      dragged     = true;
      draggedOnce = false;
    }
    
    var options = {
                    zoomControl: zoom_ctrl,
                    disableDoubleClickZoom: false,
                    zoomControlOptions: { position: google.maps.ControlPosition.RIGHT_CENTER },
                    mapTypeControl: false,
                    mapTypeControlOptions: { 
                                              style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
                                              position: position
                                            },
                    gestureHandling: 'greedy',
                  };

    var newMarker = null;
    var markers = [];
    // json for properties markers on map
    var props = json_array;
    var bounds = new google.maps.LatLngBounds();
    
    // function that adds the markers on map
    var addMarkers = function(props, map) {
      if(props != null){
        $.each(props, function(i,prop) {
            var default_icon = ''
            var price  = (prop.price == '' || prop.price == null) ? 0 : prop.price
              //default icon only when no price info available
              default_icon = new google.maps.MarkerImage(markerIcon(price, 'red'),
                    null,null,null, null)

            var latlng = new google.maps.LatLng(prop.latitude, prop.longitude);
            var marker = new google.maps.Marker({
                position: latlng,
                map: map,
                icon: default_icon,
                draggable: false,
                // animation: google.maps.Animation.DROP,
            });
            bounds.extend(marker.position);
            
            // Adding building name and address on right buildings card
            if(sidebar){ 
              createSidebar(prop, marker, map, zoom);
            }
            
            if(i == 0 || i == '0'){
              // default opening first fetured building marker
              google.maps.event.addListener(marker, 'load', (function(marker, i) {
                var object = json_array[i]
                if(object.featured){
                  loadMarkerWindow(object.id, map, marker);
                }
              })(marker, i));
            }
            google.maps.event.addListener(marker, 'click', (function(marker, i) {
              return function() {
                loadMarkerWindow(json_array[i].id, map, marker);
              }
            })(marker, i));

            // google.maps.event.addDomListener(document.getElementById(header_id),
            // 'click', function() {
            //   infobox.close();
            // });

            // google.maps.event.addDomListener(document.getElementById('content'),
            // 'click', function() {
            //   infobox.close();
            // });

            google.maps.event.addListener(map, 'click', function() {
              infobox.close();
            });         

            markers.push(marker);
        });
      }
      map.fitBounds(bounds);
      var listener = google.maps.event.addListener(map, "idle", function () {
          map.setZoom(zoom);
          google.maps.event.removeListener(listener);
      });
    }
      
    var polylineoptons = {};
    if(boundary_coords){
      polylineoptons = { 
        paths: boundary_coords, 
        strokeColor: '#1664a4', 
        strokeOpacity: 0.7, 
        strokeWeight: 2.5, 
        fillColor: '#0e5c9a', 
        fillOpacity: 0.15, 
        clickable:false 
      }
    }

    var polylines = new google.maps.Polygon(polylineoptons);

    var set_boundaries = function(map){
      brooklyn_and_queens_neighborhoods(searched_term, city, map) //In search.js
    }
    
    setTimeout(function() {
      $('body').removeClass('notransition');
      map = new google.maps.Map(document.getElementById('mapViewSearch'), options);
      //Redo search only when dragging map
      createRedoButtonObject(map)
      google.maps.event.addListener(map, 'dragend', function(){
        dragged = true;
        setRedoButtonPosition(map);
      });

      google.maps.event.addListener(map, 'zoom_changed', function() {
        zoomLevel = map.getZoom();
      });
      map.setCenter(new google.maps.LatLng(lat, lng));
      map.setZoom(zoom);
      polylines.setMap(map);
      // Setting up boundaries using kml file
      set_boundaries(map)
      addMarkers(props, map);

      var transitLayer = new google.maps.TransitLayer();
      transitLayer.setMap(map);
      windowResizeHandler(map);
      if(map && serched_by == 'latlng'){
        setCustomSearchCenter(map);
      }
    }, 300);
  }

  function setCustomSearchCenter(map){
    setTimeout(function() {
      map.setCenter(new google.maps.LatLng(lat,lng));
      redo_search = true;
    }, 500);
  }

  var windowHeight;
  var windowWidth;
  var contentHeight;
  var contentWidth;
  var isDevice = true;
  // calculations for elements that changes size on window resize
  var resizeElements = function() {
    windowHeight = window.innerHeight;
    windowWidth = $(window).width();
    contentHeight = windowHeight - $('#header').height();
    contentWidth = $('#content').width();
    $('#leftSide').height(contentHeight);
    $('.closeLeftSide').height(contentHeight);
    $('#wrapper').height(contentHeight);
    $('#mapViewSearch').height(contentHeight);
    $('#content').height(contentHeight);
  }

  var windowResizeHandler = function(map) {
    if(map){
      resizeElements();
      google.maps.event.trigger(map, 'resize');
    }
  }
  //google.maps.event.addDomListener(window, 'load', initialize);
  if(searched_term){
    initialize();
  }
}

$(document).ready(ready)
$(document).on('page:load', ready)