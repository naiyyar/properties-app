(function($) {
    "use strict";

    if(!(('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch)) {
        $('body').addClass('no-touch');
    }
    if($('#signup').length > 0){
	    $('#signup').modal({
	        backdrop: 'static',
	        keyboard: false
	    }).modal('show');
	  };

})(jQuery);

$(document).on('click', '.modal-si0', function(){
    $('.modal-suii').prop('href','javascript:void(0);').addClass('modal-su')
});