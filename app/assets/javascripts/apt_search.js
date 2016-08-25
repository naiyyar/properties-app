app.buildings = function() {
  this._input = $('#buildings-search-txt');
  this._initAutocomplete();
};

app.buildings.prototype = {
  _initAutocomplete: function() {
    this._input
      .autocomplete({
        source: '/search',
        appendTo: '#buildings-search-results',
        select: $.proxy(this._select, this)
      })
      .autocomplete('instance')._renderItem = $.proxy(this._render, this);
  },

  _render: function(ul, item) {
    window.data = item
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
    return false;
  }

};