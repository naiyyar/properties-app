app.buildings = function() {
  this._input = $('#buildings-search-txt');
  this._initAutocomplete();
};

app.buildings.prototype = {
  _initAutocomplete: function() {
    this._input
      .autocomplete({
        source: '/buildings/contribute',
        appendTo: '#buildings-search-results',
        select: $.proxy(this._select, this),
        response: $.proxy(this._response, this)
      })
      .autocomplete('instance')._renderItem = $.proxy(this._render, this);
  },

  _render: function(ul, item) {
    $("#buildings-search-no-results").css('display','none');
    var markup = [
      '<p class="address"><b>' + item.building_street_address + '</b></p>',
      '<small class="building_name">' + item.building_name + '</small>'
    ];
    
    return $('<li>')
      .append(markup.join(''))
      .appendTo(ul);
  },

  _select: function(e, ui) {
    this._input.val(ui.item.building_street_address);
    return false;
  },

  _response: function(event, ui){
    if(ui.content.length===0){
      var ul = $("#buildings-search-no-results");
      var markup = [
        '<p class="address"><b>Building Not Here?</b></p>',
        'Contribute by<a href="javascript:void(0)" id="add_new_building"> adding a new building</a>'
      ];
      
      ul_li = $('<li class="no-result-li">').append(markup.join(''));
      ul.html(ul_li);
      ul.css({'display': 'block','width': '555px','top': '36px','left': '15px'});
      
    }
  }

};