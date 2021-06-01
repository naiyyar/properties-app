//= require ./home/jquery.init
//= require bootstrap

(function($) {
  "use strict";

  setTimeout(function() {
    $('body').removeClass('notransition');
    $('.HeaderBlock').removeClass('d-none');
  }, 300);

  if(!(('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch)) {
    $('body').addClass('no-touch');
  }

  setTimeout(function() {
   	$('.alert').slideUp(300, function(){
			$(this).remove()
   	});
 	}, 1000);
 	
})(jQuery);