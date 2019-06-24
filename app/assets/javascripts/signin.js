(function($) {
    "use strict";

    setTimeout(function() {
        $('body').removeClass('notransition');
    }, 300);

    if(!(('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch)) {
        $('body').addClass('no-touch');
    }

    $('#signin').modal({
        backdrop: 'static',
        keyboard: false
    }).modal('show');

})(jQuery);

$(document).on('click', '.favourite', function(){
    $('.modal-si0').prop('href','javascript:void(0);').addClass('modal-si')
});