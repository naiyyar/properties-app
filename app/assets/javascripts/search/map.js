var ready = function(){
  var position;
  var currentLocation;
  var props;
  var bounds;
  var newMarker;
  var markers;
  var options;
  var json_array = $('#json-hash').data('buildingshash');
  zoom = parseInt($('.zoom').val());
  localStorage.setItem('mapZoom', zoom);
  lat = $('#lat').data('lat');
  lng = $('#lng').data('lng');
  var serched_by    = $('#searched_by').val();
  var searched_term = $('#search_term').val();
  var search_string = $('#search_string').val();
  var city          = '';
  var header_id     = $('#app-header').length > 0 ? 'app-header' : 'header-mob';
  var boundary_coords = $('#boundary_coords').data('coords');
  var polylines;
  var transitLayer;
  map_init_count = 0;
  current_user_id   = $('#cu').val();
  redo_search       = false;
  dragged           = false;
  draggedOnce       = false;
  zoomLevel         = zoom;
  featured_building_id = null;
  featured_marker = null;
  infobox_data_html = null;
  infobox_opened = false;
  map = null;
  
  if(searched_term && search_string){
    searched_term = search_string;
    if(searched_term && searched_term == 'Little Italy'){
      var city = searched_term.includes('newyork') ? 'New York' : 'Bronx'
    }
  }

  // Custom options for map
  window.initialize = function(sidebar = true) {
    var zoom_ctrl = true;
    if(mobile){
      position  = google.maps.ControlPosition.TOP_LEFT;
      zoom_ctrl = false;
    }else{
      position  = google.maps.ControlPosition.TOP_CENTER;
    }
    if(!sidebar){
      dragged     = true;
      draggedOnce = false;
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
    
    var options = {
                    zoomControl: zoom_ctrl,
                    disableDoubleClickZoom: false,
                    zoomControlOptions: { 
                      position: google.maps.ControlPosition.RIGHT_CENTER 
                    },
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
    var markers_added = false;
    // function that adds the markers on map
    var addMarkers = function(props, map) {
      if(props != null){
        markers_added = true;
        $.each(props, function(i,prop) {
            var default_icon = ''
            var price  = (prop.price == '' || prop.price == null) ? 0 : prop.price
              // default icon only when no price info available
              default_icon = new google.maps.MarkerImage(markerIcon(price, 'red'),
                    null,null,null, null)

            var latlng = new google.maps.LatLng(prop.latitude, prop.longitude);
            var marker = new google.maps.Marker({
                position: latlng,
                map: map,
                icon: default_icon,
                draggable: false
            });
            bounds.extend(marker.position);
            
            // Adding building name and address on right buildings card
            if(sidebar){ 
              createSidebar(prop, marker, map);
            }
            
            if(i == 0 || i == '0'){
              // default opening first fetured building marker
              google.maps.event.addListener(marker, 'load', (function(marker, i) {
                var object = json_array[i];
                if(object.featured){
                  featured_building_id = object.id
                  featured_marker = marker;
                  if(infobox_data_html){
                    infobox.setContent(infobox_data_html);
                    openInfoBox(map, featured_marker);
                  }
                  else{
                    loadMarkerWindow(object.id, map, marker, prop.property_type);
                  }
                }
              })(marker, i));
            }
            google.maps.event.addListener(marker, 'click', (function(marker, i) {
              return function() {
                loadMarkerWindow(json_array[i].id, map, marker, prop.property_type);
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
      // var listener = google.maps.event.addListener(map, "idle", function () {
      //     google.maps.event.removeListener(listener);
      // });
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

    polylines = new google.maps.Polygon(polylineoptons);
    var set_boundaries = function(map){
      brooklyn_and_queens_neighborhoods(searched_term, city, map)
    }
  
    setTimeout(function() {
      $('body').removeClass('notransition');
      if(!map){
        map = new google.maps.Map(document.getElementById('mapViewSearch'), options);
      }
    
      createRedoButtonObject(map);
      google.maps.event.addListener(map, 'dragend', function(){
        dragged = true;
        setRedoButtonPosition(map);
      });

      if(polylines){
        polylines.setMap(map);
      }
      // Setting up boundaries using kml file
      set_boundaries(map);
      if(!markers_added){
        addMarkers(props, map);
      }
      if(!transitLayer){
        transitLayer = new google.maps.TransitLayer();
      }
      transitLayer.setMap(map);
      windowResizeHandler(map);
      if(map && serched_by == 'latlng'){
        setCustomSearchCenter(map);
      }
      google.maps.event.addListener(map, 'zoom_changed', function() {
        var zoom_val = parseInt(map.getZoom());
        zoomLevel = zoom_val;
        if( zoom_val < zoom) {
          zoom_val = zoom
        }
        localStorage.mapZoom = zoom_val;
      });
      map.setZoom(13);
    }, 300);
  }

  setTimeout(function() {
    if(map){
      setMapCenter(map);
      setMapzoom(map)
    }
  }, 400);

  function setCustomSearchCenter(map){
    setTimeout(function() {
      setMapCenter(map);
      setMapzoom(map)
      redo_search = true;
    }, 500);
  }

  function setMapCenter(map){
    if(map){
      map.setCenter(new google.maps.LatLng(lat,lng));
    }
  }

  function setMapzoom(map){
    if(map){
      map.setZoom(zoomNum());
    }
  }

  function zoomNum(){
    var zoomNum = zoomLevel;
    if(zoomLevel < 13 || zoomLevel > 18){
      zoomNum = 13
    } 
    return zoomNum;
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
  if($('#mapViewSearch').length > 0){
    initialize();
  }

  // setting up building and agent image on search view card
  var cards = $('.searched-properties .search-view-card');
  if(cards.length > 0){
    cards.each(function(i, j){
        var agentid = $(j).data('agentid');
        if(agentid){
          Card.loadFeaturedAgentImagesAndCTALinks(agentid);
        }else{
          Card.loadDisplayImageAndCTALinks($(j));
        }
    });
  }

}

$(document).ready(ready)
$(document).on('page:load', ready)