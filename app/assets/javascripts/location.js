var location_url = 'javascript:void(0);';
function getLocation(){
  if (navigator.geolocation) {
    var options = {enableHighAccuracy: true, timeout: 60000, maximumAge: 0};
    navigator.geolocation.getCurrentPosition(showPosition, showError, options);
    //$('.location-loader').show();
  } else {
    alert("Geolocation is not supported by this browser.");
  }
}

function showPosition(position) {
  var loc_link = $('.ui-autocomplete li.curr-location a');
  render_url = '/location_search?latitude='+position.coords.latitude+'&longitude='+position.coords.longitude;
  if(loc_link.attr('href') == 'javascript:void(0);'){
    window.location.href = render_url;
  }
  loc_link.attr('href', render_url);
}

function showError(error) {
  switch(error.code) {
    case error.PERMISSION_DENIED:
      alert("Transparentcity doesn't have permission to access your location. Please check your browser location settings.");
      break;
    case error.POSITION_UNAVAILABLE:
      alert("Location information is unavailable.");
      break;
    case error.TIMEOUT:
      console.log("The request to get user location timed out.");
      break;
    case error.UNKNOWN_ERROR:
      console.log("An unknown error occurred.");
      break;
  }
}

navigator.permissions && navigator.permissions.query({name: 'geolocation'}).then(function(PermissionStatus) {
  if(PermissionStatus.state == 'granted'){
    //console.log('allowed')
    getLocation();
  }else{
    //window.data = PermissionStatus
    //PermissionStatus.state = 'prompt'
    // setTimeout(function(){
    //   $('.icon-location').tooltip('show'); 
    // }, 2000);
  }
});