$(document).ready(function() {
	if($('#pop-nyc-neighborhoods-list').length > 0){
	  $.ajax({
	    url: '/lazy_load_content',
	    type: 'get',
	    dataType: 'script'
	  });
	}
});