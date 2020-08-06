//= require ./home/jquery.init
//= require bootstrap/dropdown

(function($) {
  "use strict";

  setTimeout(function() {
    $('body').removeClass('notransition');
  }, 300);

  if(!(('ontouchstart' in window) || window.DocumentTouch && document instanceof DocumentTouch)) {
    $('body').addClass('no-touch');
  }
})(jQuery);