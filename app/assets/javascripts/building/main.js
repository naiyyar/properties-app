//= require bootstrap/button
//= require underscore
//= require jquery.fancybox
//= require lightslider
//= require gmap
//= require ./show_map_handler

// clear text search
$('.clearSearchText').click(function(){
    $("#search_term").val('');
});

// search box text seletion on click
$("#apt-search-txt-searchpage, #search_term").click(function () {
  $(this).select();
});

//
// For mobile neighborhoods dropdown toggle
$('.dropdown-toggle-neighborhoods, .closeHoods').click(function(e) {
  $('.popular-neighborhoods').slideToggle(200, 'linear', function(){
    var elem             = $('#wrapper.screen-sm');
    var toggleable_class = 'no-touch-scroll'
    $(this).is(':hidden') ? elem.removeClass(toggleable_class) : elem.addClass(toggleable_class);
  });
});

$(document).ready(function() {
  if($('#sh-slider').length > 0) {
    var building_id = $('#cu_building_id').val();
    $.ajax({
      url: '/buildings/'+building_id+'/lazy_load_content',
      dataType: 'script',
      type: 'get',
      success: function(){}
    });
  }
});

// lightSlider
// var sl_container = $('.sh-slider-container');
// if(sl_container.length > 0) {
//   var thumb_images_length = $('.lSPager.lSGallery').children().length;
//   var add_class           = thumb_images_length == 0 ? 'no-thumb' : 'with-thumb';
//   var show_gallery        = sl_container.find('.gallery');
//   if(show_gallery){
// 	  show_gallery.lightSlider({
// 	    gallery: true,
// 	    item: 1,
// 	    slideMargin: 0,
// 	    loop: true,
// 	    thumbItem: 6,
// 	    galleryMargin: 1,
// 	    addClass: add_class,
// 	    onBeforeSlide: function(el, scene){
// 	      parent_elem     = el.parent().parent();
// 	      show_count_elem = parent_elem.prev();
// 	      current_elem    = show_count_elem.find('.current');
// 	      current_elem.text(el.getCurrentSlideCount);
// 	    }
// 	  });
//     var elem = $('.sh-slider-container .lightSlider .lslide a');
//     if(elem && elem.length > 0){
//   	 Transparentcity.initFancybox('.sh-slider-container .lightSlider .lslide a');
//     }
//   	$('#sh-slider').css('background', '#fff');
//   }
// }

// For featured Comps buildings
//
if($('.search-view-card').length > 0){
  $('.search-view-card').each(function(i, j){
    Card.loadDisplayImageAndCTALinks($(j).data('bid'));
  });
}