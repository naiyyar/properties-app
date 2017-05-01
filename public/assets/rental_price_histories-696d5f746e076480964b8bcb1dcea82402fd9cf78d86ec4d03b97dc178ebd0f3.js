(function() {
  jQuery(function() {
    $('#rental_price_history_residence_end_date').on('changeDate', function(e) {
      var end_date, start_date;
      start_date = $("#rental_price_history_residence_start_date").val();
      end_date = $("#rental_price_history_residence_end_date").val();
      if (Date.parse(start_date) > Date.parse(end_date)) {
        $('.validation_error_message').removeClass('hidden');
        return $("#rental_price_history_residence_end_date").val('');
      } else {
        return $('.validation_error_message').addClass('hidden');
      }
    });
    return $('#rental_price_history_residence_start_date').on('changeDate', function(e) {
      var end_date, start_date;
      start_date = $("#rental_price_history_residence_start_date").val();
      end_date = $("#rental_price_history_residence_end_date").val();
      if (Date.parse(start_date) > Date.parse(end_date)) {
        $('.start_validation_error_message').removeClass('hidden');
        return $("#rental_price_history_residence_start_date").val('');
      } else {
        return $('.start_validation_error_message').addClass('hidden');
      }
    });
  });

}).call(this);
