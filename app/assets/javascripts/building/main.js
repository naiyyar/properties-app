//= require bootstrap/button
//= require underscore
//= require jquery.fancybox
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