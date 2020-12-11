var location_url = 'javascript:void(0);';
function getLocation(){
  document.getElementById('search_term').value = 'Current Location';
  navigator.permissions && navigator.permissions.query({name: 'geolocation'}).then(function(PermissionStatus) {
    if(PermissionStatus.state == 'granted'){
      if (navigator.geolocation) {
        var options = {enableHighAccuracy: true, timeout: 60000, maximumAge: 0};
        navigator.geolocation.getCurrentPosition(showPosition, showError, options);
      } else {
        alert("Geolocation is not supported by this browser.");
      }
    }
    else{
      console.log("Permission not granted. status_type:"+PermissionStatus.state);
    }
  });
}

function showPosition(position) {
  var loc_link = $('.ui-autocomplete li.curr-location a');
  if(loc_link.attr('href') == 'javascript:void(0);'){
    window.location.href = render_url(position);
  }
  loc_link.attr('href', render_url(position));
}

function render_url(position){
  return '/location_search?latitude='+position.coords.latitude+'&longitude='+position.coords.longitude+'&searched_by=current_location';
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