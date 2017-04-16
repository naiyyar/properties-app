app.apartments = function() {
  this._input = $('#apt-search-txt, #apt-search-txt-searchpage');
  this._initAutocomplete();
};

app.apartments.prototype = {
  _initAutocomplete: function() {
    this._input
      .autocomplete({
        source: '/search',
        appendTo: '#apt-search-results',
        select: $.proxy(this._select, this)
      })
      .autocomplete('instance')._renderItem = $.proxy(this._render, this);
  },

  _render: function(ul, item) {
    if(item.search_term == undefined){
      search_term = item.value
    }
    else{
      search_term = item.search_term
    }
    var markup = [
      '<p class="address"><b>' + search_term + '</b></p>'
    ];
    $('ul.ui-autocomplete').css('left','10');
    return $('<li>')
      .append(markup.join(''))
      .appendTo(ul);
  },

  _select: function(e, ui) {
    this._input.val(ui.item.search_term);
    $("#term").val(ui.item.term);
    $("#neighborhoods").val(ui.item.neighborhoods);
    $("#apt-search-txt-form").val(ui.item.search_term);
    $('#apt-search-form').find('.in_header').click();
    return false;
  }

};