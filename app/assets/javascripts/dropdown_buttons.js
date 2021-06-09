var DPButtons = (function(){
	var elm_filter;
	var dp_sort;
	var dp_filter;
	var btn_dp_sort;
	var btn_dp_filter;
	var dp_t;
	
	var init = function(){
		elm_filter 					 = $('.filter');
		dp_sort 				 		 = $('.btn-sort');
		dp_filter 			 		 = $('.btn-filter');
		btn_dp_sort 				 = dp_sort.find('button.dropdown-toggle');
		btn_dp_filter 			 = dp_filter.find('button.handleFilter');
		dp_t 								 = $('#search-row .dropdown-toggle');
	};
	var handleFilter = function(){
		elm_filter.slideToggle(200);
    dp_filter.toggleClass('open');
	};

	var closeDropdowns = function(current_elem, type){
		if(type == 'filter' && elm_filter.is(':visible')){
      elm_filter.hide();
      dp_filter.removeClass('open');
    }else if (type=='other'){
      var parent_el = dp_t.parent();
      if(parent_el.hasClass('open')){
        parent_el.removeClass('open');
        current_elem.parent().addClass('open');
      }
    }
	};

	return {
		init: 					init,
		handleFilter: 	handleFilter,
		closeDropdowns: closeDropdowns
	};
})();