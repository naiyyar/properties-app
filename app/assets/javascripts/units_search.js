app.units = function(building_id) {
  this._input = $('#units-search-txt');
  this._initAutocomplete(building_id);
};

app.units.prototype = {
  _initAutocomplete: function(building_id) {
    this._input
      .autocomplete({
        source: '/units/units_search?building_id='+building_id,
        appendTo: '#units-search-results',
        select: $.proxy(this._select, this),
        response: $.proxy(this._response, this)
      })
      .autocomplete('instance')._renderItem = $.proxy(this._render, this);
  },

  _render: function(ul, item) {
    $("#units-search-no-results").css('display','none');
    var markup = [
      '<p class="address"><b>' + item.name + '</b></p>'
    ];
    
    return $('<li>')
      .append(markup.join(''))
      .appendTo(ul);
  },

  _select: function(e, ui) {
    this._input.val(ui.item.name);
    var unitContri = $("#unit_contribution").val();
    if(unitContri == 'unit_review' || unitContri == 'unit_photos' || unitContri == 'unit_amenities' || unitContri == 'unit_price_history'){
      if(unitContri == 'unit_review'){
        href = '/reviews/new'
        $("#new_unit_building").attr('action', href);
        $("#new_unit_building").attr('method', 'get');
      }
      $("#new_unit_building").removeClass('hide');
      // if($("#unit_name").hasClass('hide')){
      //   $("#unit_name").removeClass('hide');
      // }
      var unit = ui.item;
      $("#unit_id").val(unit.id);
      $("#unit_name").val(unit.name);
      $("#unit_square_feet").val(parseInt(unit.square_feet));
      $("#unit_number_of_bedrooms").val(unit.number_of_bedrooms);
      $("#unit_number_of_bathrooms").val(unit.number_of_bathrooms);
      if(unitContri == 'unit_amenities'){
        href = "/units/"+unit.id+"/edit"
        $('#search_item_form').attr('action', href);
      }
    }
    return false;
  },

  _response: function(event, ui){
    if(ui.content.length===0){
      var ul = $("#units-search-no-results");
      var markup = [
        '<p class="address"><b>Unit Not Here?</b></p>',
        'Contribute by<a href="javascript:void(0)" id="add_new_unit"> adding a new unit</a>'
      ];
      
      ul_li = $('<li class="no-result-li">').append(markup.join(''));
      ul.html(ul_li);
      ul.css({'display': 'block','width': '555px','top': '36px','left': '15px'});
      
    }
  }

};