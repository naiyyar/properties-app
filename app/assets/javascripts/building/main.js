//= require bootstrap/button
//= require underscore
//= require jquery.fancybox
//= require lightslider
//= require gmap
//= require search_modal
//= require ./show_map_handler


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
    var object_id = $('#cu_object_id').val();
    var type = $('#cu_object_type').val();
    $.ajax({
      url: '/uploads/'+object_id+'/lazy_load_images',
      dataType: 'script',
      type: 'get',
      data: { object_type: type },
      success: function(){}
    });
  }
});

// For featured Comps buildings
//
var svc = $('.search-view-card');
if(svc.length > 0){
  svc.each(function(i, j){
    Card.loadDisplayImageAndCTALinks($(j).data('bid'));
  });
}