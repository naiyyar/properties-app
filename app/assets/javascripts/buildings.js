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
    var unitContri = $("#unit_contribution").val();
    if(unitContri == 'unit_review' || unitContri == 'unit_photos' || unitContri == 'unit_amenities' || unitContri == 'unit_price_history'){
      $("#new_unit_building #building_building_street_address").val(ui.item.building_street_address);
      $("#new_unit_building #building_building_name").val(ui.item.building_name)
      if(ui.item.units.length > 0){
        if(ui.item.units.length == 1){
          if($("#unit_name").hasClass('hide')){
            $("#unit_name").removeClass('hide');
          }
          var unit = ui.item.units[0] ;
          $("#unit_id").val(unit.id);
          $("#unit_name").val(unit.name);
          $("#unit_square_feet").val(parseInt(unit.square_feet));
          $("#unit_number_of_bedrooms").val(unit.number_of_bedrooms);
          $("#unit_number_of_bathrooms").val(unit.number_of_bathrooms);
          $("#unit_names_list_select").removeAttr('name');
        }
        else{
          $("#unit_name").addClass('hide');
          var unit_select = $("#unit_names_list_select")
          unit_select.html('');
          $.each(ui.item.units, function (i, item) {
            unit_select.append($('<option>', { 
                value: item.id,
                text : item.name 
            }));
          });
          $("#unit_id").val(ui.item.units[0].id);
          $("#unit_square_feet").val(parseInt(ui.item.units[0].square_feet));
          $("#unit_number_of_bedrooms").val(ui.item.units[0].number_of_bedrooms);
          $("#unit_number_of_bathrooms").val(ui.item.units[0].number_of_bathrooms);
          unit_select.removeClass('hide');
        }
      }
      else{
        if($("#unit_name").hasClass('hide')){
          $("#unit_name").removeClass('hide');
        }
        $("#unit_id").val('')
        $("#unit_names_list_select").removeAttr('name').addClass('hide');
        $("#unit_square_feet").val('');
        $("#unit_number_of_bedrooms").val('');
        $("#unit_number_of_bathrooms").val('');
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