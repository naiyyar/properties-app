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

Photo = {
	loadDisplayImage: function(building_id){
	  var elem = $("#figure"+building_id);
	  var enable_touch = !($('#featured-buildings-section').length > 0);
	  $.ajax({
	    url: '/get_images',
	    dataType: 'json',
	    type: 'get',
	    data: { building_id: building_id },
	    success: function(response){
	      elem.html(response.html);
	      Photo.initLightSlider(elem.find('.gallery'), enable_touch);
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