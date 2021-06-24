//= require underscore
//= require jquery.fancybox
//= require lightslider
//= require gmap
//= require search_modal
//= require featured_listings
//= require useful_reviews
//= require jquery.raty
//= require ratyrate
//= require property_card_actions
//= require infobubble
//= require ./show_map_handler
//= require ./map


// For mobile neighborhoods dropdown toggle
$('.dropdown-toggle-neighborhoods, .closeHoods').click(function(e) {
  $('.popular-neighborhoods').slideToggle(200, 'linear', function(){
    var elem = $('#wrapper.screen-sm');
    var toggleable_class = 'no-touch-scroll'
    $(this).is(':hidden') ? elem.removeClass(toggleable_class) : elem.addClass(toggleable_class);
  });
});

$(document).ready(function() {
  if($('#sh-slider').length > 0) {
    var object_id = $('#cu_object_id').val();
    var type = $('#cu_object_type').val();
    $.ajax({
      url: '/uploads/'+object_id+'/lazy_load_images',
      dataType: 'script',
      type: 'get',
      data: { object_type: type },
      success: function(){
        // console.log('lazy_load_images success')
      }
    });
  }
});

// For featured Comps buildings
//
var svc = $('.search-view-card');
if(svc.length > 0){
  svc.each(function(i, j){
    Card.loadDisplayImageAndCTALinks($(j));
  });
}
if($('.ca.mobile').length > 0){
  $('.ca.mobile').on('click', function(){
    window.open(this.href, '_blank');
    return false;
  });
}

// Prevent remote: true links opening in new tabs or windows
$.each($("a[data-remote='true']"), function(i, val) {
  $(val).data("url", $(val).attr("href")).attr("href", "javascript:void(0);")
});

$.rails.href = function(el) {
  var $el = $(el);
  return $el.data('url') || $el.data('href') || $el.attr('href');
}