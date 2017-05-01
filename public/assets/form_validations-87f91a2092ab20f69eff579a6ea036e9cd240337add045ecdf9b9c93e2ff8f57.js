(function() {
  jQuery(function() {
    return $(document).on('click', "form", function(e) {
      var elems, i, j, len, ref, submit;
      submit = true;
      window.data = $(this);
      elems = $(this).find('.validate');
      len = elems.length - 1;
      for (i = j = 0, ref = len; j <= ref; i = j += 1) {
        if ($(elems[i]).val() === '' || $(elems[i]).val() === '0.0') {
          $(elems[i]).parent().addClass('has-error');
          submit = false;
        } else {
          $(elems[i]).parent().removeClass('has-error');
        }
      }
      return submit;
    });
  });

}).call(this);
