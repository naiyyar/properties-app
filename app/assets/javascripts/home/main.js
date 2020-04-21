//= require jquery-ui.min
//= require jquery-ui-touch-punch
//= require bootstrap/modal
//= require bootstrap/dropdown
//= require lightslider
//= require slick.min
//= require location
//= require left_nav
//= require devise
//= require detect_timezone
//= require jquery.detect_timezone
//= require saved_buildings
//= require bootbox.min
//= require jquery.mask.min
//= require mask
//= require ./search

setTimeout(function(){ 
	$('.alert').slideUp(300);
}, 3000);

Card = {
	loadDisplayImageAndCTALinks: function(building_id){
	  var fig_elem 			= $("#figure"+building_id);
	  var cta_elem 			= $("#cta-links"+building_id);
	  var filter_params = $('#filter-params').data('filterparams');
	  var enable_touch 	= !($('#featured-buildings-section').length > 0);
	  $.ajax({
	    url: '/get_images',
	    dataType: 'json',
	    type: 'get',
	    data: { building_id: building_id },
	    success: function(response){
	      fig_elem.html(response.html);
	      Card.initLightSlider(fig_elem.find('.gallery'), enable_touch);
	      cta_elem.html(response.cta_html);
	    }
	  });
	},

	initLightSlider: function(elem, enable_touch){
	  elem.lightSlider({
	    item: 1,
	    slideMargin: 0,
	    loop: true,
	    enableDrag: enable_touch,
	    enableTouch: enable_touch,
	    onBeforeSlide: function(el) {
	       show_count_elem = el.parent().parent().prev();
	       current_elem = show_count_elem.find('.current');
	       current_elem.text(el.getCurrentSlideCount);
	     }
	  });
	}
}