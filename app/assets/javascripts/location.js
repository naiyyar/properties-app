var location_url = 'javascript:void(0);';
function getLocation(){
  document.getElementById('search_term').value = 'Current Location';
  // PermissionStatus is not working in ios mobiles devices. Returing undefined PermissionStatus.state
  // navigator.permissions && navigator.permissions.query({name: 'geolocation'}).then(function(PermissionStatus) {
  // if(PermissionStatus.state == 'granted'){
  if (navigator.geolocation) {
    var options = {enableHighAccuracy: true, timeout: 60000, maximumAge: 0};
    navigator.geolocation.getCurrentPosition(showPosition, showError, options);
  } else {
    alert("Geolocation is not supported by this browser.");
  }
  // }
  // else{
  //   alert("Permission not granted. state_type:"+PermissionStatus.state);
  // }
  // });
}

function showPosition(position) {
  var loc_link = $('.ui-autocomplete li.curr-location a');
  var url_to_render = render_url(position);
  if(loc_link.attr('href') == 'javascript:void(0);'){
    setTimeout(function(){document.location.href = url_to_render}, 250);
  }
  loc_link.attr('href', url_to_render);
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
      alert("The request to get user location timed out.");
      break;
    case error.UNKNOWN_ERROR:
      alert("An unknown error occurred.");
      break;
  }
}