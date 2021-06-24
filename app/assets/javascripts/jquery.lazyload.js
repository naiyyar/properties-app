$(document).ready(function() {
	if($('#pop-nyc-neighborhoods-list').length > 0){
		var filter_params = $('#filter-params').data('filterparams');
		var searched_by = $('#searched_by').val();
		var search_term = $('#nb-search-term').val();
		var sortedby = $('#filter-params').data('sortedby');
	  $.ajax({
	    url: '/lazy_load_content',
	    type: 'get',
	    dataType: 'script',
	    data: { 
	    				filter: filter_params, 
	    				search_term: search_term, 
	    				searched_by: searched_by,
	    				sort_by: sortedby
	    			}
	  });
	}
});