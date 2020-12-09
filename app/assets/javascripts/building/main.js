//= require bootstrap/button
//= require underscore
//= require jquery.fancybox
//= require lightslider
//= require gmap
//= require search_modal
//= require ./show_map_handler

// clear text search
$('.clearSearchText').click(function(){
    $("#search_term").val('');
});

$('#search_term.screen-sm').on('focus', function(){
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

// For featured Comps buildings
//
if($('.search-view-card').length > 0){
  $('.search-view-card').each(function(i, j){
    Card.loadDisplayImageAndCTALinks($(j).data('bid'));
  });
}