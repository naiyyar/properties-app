function getLocation(){
  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(showPosition, showError);
  } else {
    alert("Geolocation is not supported by this browser.");
  }
}

function showPosition(position) {
  var loc_link = $('.hyper-link.location');
  //loc_link.parent().addClass('loc-allowed');
  var url = '/location_search?latitude='+position.coords.latitude+'&longitude='+position.coords.longitude;
  loc_link.attr('href', url);
}

function showError(error) {
  switch(error.code) {
    case error.PERMISSION_DENIED:
      alert("User denied the request for Geolocation.");
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

navigator.permissions && navigator.permissions.query({name: 'geolocation'}).then(function(PermissionStatus) {
  if(PermissionStatus.state == 'granted'){
    //console.log('allowed')
    getLocation();
  }else{
    console.log('denied')
  }
});