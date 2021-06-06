(function($) {
    "use strict";

    if(!(('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch)) {
        $('body').addClass('no-touch');
    }
    if($('#signin').length > 0){
	    $('#signin').modal({
	        backdrop: 'static',
	        keyboard: false
	    }).modal('show');
	  }

})(jQuery);

$(document).on('click', '.favourite', function(){
    $('.modal-si0').prop('href','javascript:void(0);').addClass('modal-si')
});