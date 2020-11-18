//
//**** REDO BUTTON SCRIPTS   ****
//
function setRedoButtonPosition(map){
  controlUI.style.display = 'block';
  if(!draggedOnce){
    centerControlDiv.index = 1;
    if(mobile){       
      map.controls[google.maps.ControlPosition.TOP_CENTER].push(centerControlDiv);
    }else{
      map.controls[google.maps.ControlPosition.TOP_LEFT].push(centerControlDiv);
    }
    draggedOnce = true;
  }
}

function getMoveData(map){
  if(dragged){
    currentLocation = map.getCenter()
    lat = currentLocation.lat();
    lng = currentLocation.lng();
    var query_strings = window.location.search;
    var orginal_url = '/custom_search';
    var new_loc_url = '';
    var q_params = 'latitude='+lat+'&longitude='+lng+'&zoomlevel='+zoomLevel;
    if(query_strings.includes('sort_by') || query_strings.includes('filter')){
      new_loc_url = orginal_url+query_strings+'&'+q_params;
    }else{
      new_loc_url = orginal_url+'?'+q_params;
    }
    location.href = new_loc_url+'&searched_by=latlng&search_term=custom';
  }
}

function createRedoButtonObject(map){
  centerControlDiv = document.createElement('div');
  centerControl = new RedoButton(centerControlDiv, map);
}

function RedoButton(controlDiv, map) {
  // Set CSS for the control border.
  controlUI = document.createElement('div');
  controlUI.style.backgroundColor = '#2b78e4';
  controlUI.style.borderRadius    = '90px';
  controlUI.style.boxShadow       = '0 2px 6px rgba(0,0,0,.3)';
  controlUI.style.cursor          = 'pointer';
  controlUI.style.marginTop       = '8px';
  controlUI.style.marginLeft      = mobile ? '8px' : '';
  controlUI.style.textAlign       = 'center';
  controlUI.style.display         = 'none';
  controlDiv.appendChild(controlUI);

  // Set CSS for the control interior.
  controlText = document.createElement('div');
  controlText.style.color = '#fff';
  //controlText.style.fontFamily = 'Roboto,Arial,sans-serif';
  controlText.style.fontSize      = '14px';
  controlText.style.lineHeight    = '30px';
  controlText.style.paddingLeft   = '8px';
  controlText.style.paddingRight  = '8px';
  controlText.innerHTML = '<span class="fa fa-refresh"></span> Redo Search Here';
  controlUI.appendChild(controlText);

  controlUI.addEventListener('click', function() {
    getMoveData(map);
  });
}

//****   End Redo button   ****