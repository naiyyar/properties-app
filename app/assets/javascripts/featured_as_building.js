app.AsCompBuildings = function() {
  this._input = $('#feature_building_as_comp');
  source_url = $('#feature_building_as_comp').data('src');
  this._initAutocomplete();
};

app.AsCompBuildings.prototype = {
  _initAutocomplete: function() {
    this._input
      .autocomplete({
        source: source_url,
        prependTo: '#as-comp-buildings-search-results',
        select: $.proxy(this._select, this),
        //response: $.proxy(this._response, this),
        open: $.proxy(this._open, this),
        search: $.proxy(this._search, this),
        close: $.proxy(this._close, this)
      })
      .autocomplete('instance')._renderItem = $.proxy(this._render, this);
  },

  _search: function(e,ui){
    this._input.addClass('loader');
  },

  _open: function(event, ui) {
    this._input.removeClass('loader');
  },

  _render: function(ul, item) {
    var markup = [];
    var building_name = ''
    if(item.building_name == '' || item.building_name == undefined){
      building_name = item.building_street_address;
    }else{
      building_name = item.building_name;
    }
    if(item.value != 'No matches found'){
      markup.push('<p class="address"><b>'+item.building_address+'</b></p>',
        '<small class="building_name">'+building_name+'</small>');
    }
    
    return $('<li>')
      .append(markup.join(''))
      .appendTo(ul);
  },

  _select: function(e, ui) {
    var item = '';
    //featured_comp form top search field
    if(ui.item.featured_search_type === 'feature_comp_as'){
      $('#feature_building_as_comp').val(ui.item.building_address)
      $('#featured_comp_building_id').val(ui.item.id)
    }

    return false;
  },

  _close: function(){
    //Hiding no match found - add new building link
   if(!$("ul.ui-autocomplete").is(":visible")) {
      $("ul.ui-autocomplete").show();
    }
  },

};