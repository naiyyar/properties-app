// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require ./home/jquery.init
//= require ./home/main
//= require rails.validations
//= require bootstrap/tooltip
//= require bootstrap/carousel
//= require bootstrap/button
//= require jquery-placeholder
//= require jquery.slimscroll.min
//= require jquery.tagsinput.min
//= require underscore
//= require jquery.raty
//= require ratyrate
//= require bootstrap-datepicker
//= require jquery.validate
//= require jquery.touchSwipe.min
//= require jquery-sortable-photos
//= require jquery.dataTables.min
//= require jquery-fileupload/basic
//= require moment
//= require bootstrap-datetimepicker
//= require bootstrap-multiselect
//= require filterrific/filterrific-jquery
//= require load_more
//= require input_validations
//= require jquery.mask.min
//= require jquery.fancybox
//= require form_validations
//= require social-share-button
//= require review_form
//= require_tree .


(function($) {
	// Enable swiping
  $(".carousel").swipe({
    swipe: function(event, direction, distance, duration, fingerCount) {
      if(direction == "left") { $(this).carousel("next"); }
      if(direction == "right") { $(this).carousel("prev"); }
    },
    // threshold: 0
  });
})(jQuery);