app.apartments = function() {
  this._input = $('#apt-search-txt');
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
    //window.data = item
    var markup = [
      '<p class="address"><b>' + item.search_term + '</b></p>'
    ];
    
    return $('<li>')
      .append(markup.join(''))
      .appendTo(ul);
  },

  _select: function(e, ui) {
    this._input.val(ui.item.search_term);
    $("#term").val(ui.item.term)
    $("#neighborhoods").val(ui.item.neighborhoods)
    return false;
  }

};