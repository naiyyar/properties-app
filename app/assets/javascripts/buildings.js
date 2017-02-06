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
      '<p class="address"><b>' + item.building_street_address + '</b></p><br/>',
      '<small class="building_name">' + item.building_name + '</small>'
    ];
    
    return $('<li>')
      .append(markup.join(''))
      .appendTo(ul);
  },

  _select: function(e, ui) {
    $('#units-search-txt').val('');
    $("#new_unit_building").addClass('hide');
    new app.units(ui.item.id);
    this._input.val(ui.item.building_street_address);
    var unitContri = $("#unit_contribution").val();
    var buildingContri = $("#contribution").val();
    if(buildingContri == 'building_amenities'){
      href = "/buildings/"+ui.item.id+"/edit"
      $('#search_item_form').attr('action', href);
    }
    if(unitContri == 'unit_review' || unitContri == 'unit_photos' || unitContri == 'unit_amenities' || unitContri == 'unit_price_history'){
      $("#new_unit_building #building_building_street_address").val(ui.item.building_street_address);
      $("#new_unit_building #building_building_name").val(ui.item.building_name);
      $(".unit-search").removeClass('hide');
      if(!$("#unit_name").parent().parent().hasClass('hide')){
        $("#unit_name").parent().parent().addClass('hide')
      }
    }
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