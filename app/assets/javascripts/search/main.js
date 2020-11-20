//= require bootstrap/button
//= require bootstrap/tab
//= require underscore
//= require jquery.touchSwipe.min
//= require jquery.slimscroll.min
//= require jquery.add_kml
//= require jquery.fancybox
//= require filters
//= require gmap
//= require back_to_scroll_position
//= require infobubble
//= require swiper.jquery
//= require dropdown_buttons
//= require jquery.validate
//= require price_slider
//= require home
//= require ./redo_button


// Avoid dropdown menu close on click inside
$(document).on('click', '.neighborhoods-dropdown .dropdown-menu', function (e) {
    e.stopPropagation();
});

if($('.handleFilter').length > 0){
    $('.handleFilter, .closeFilter').click(function(e) {
        e.stopPropagation();
        DPButtons.init();
        DPButtons.handleFilter()
        initSlider();
        DPButtons.closeDropdowns($(this), 'other');
    });

    $(document).on('click', '.dropdown-toggle', function(){
        DPButtons.init();
        DPButtons.closeDropdowns($(this), 'filter');
    });
}

$(document).click(function(e) {
    e.stopPropagation();
    if($(e.target).closest('.filter').length === 0){
        if($('.filter').is(':visible')){
            $('.filter').slideUp(200);
        }
    }
});

$('.handleSort').click(function(e) {
    $('.sortMenu').slideToggle(200);
});
