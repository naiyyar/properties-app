// app.units = function(building_id) {
//   this._input = $('#units-search-txt');
//   this._initAutocomplete(building_id);
// };

// app.units.prototype = {
//   _initAutocomplete: function(building_id) {
//     this._input
//       .autocomplete({
//         source: '/units/units_search?building_id='+building_id,
//         appendTo: '#units-search-results',
//         select: $.proxy(this._select, this),
//         response: $.proxy(this._response, this),
//         open: $.proxy(this._open, this)
//       })
//       .autocomplete('instance')._renderItem = $.proxy(this._render, this);
//   },

//   _open: function(event, ui) {
//     $('.ui-autocomplete').append('<li class="ui-menu-item building_link_li"><span class="address"><b>Unit Not Here?</b></span> <a href="javascript:void(0)" id="add_new_unit" class="add_new_unit"> Add a Unit</a></li>');
//   },

//   _render: function(ul, item) {
//     $("#units-search-no-results").css('display','none');
//     var markup = [
//       '<p class="address"><b>' + item.name + '</b></p>'
//     ];
    
//     return $('<li>')
//       .append(markup.join(''))
//       .appendTo(ul);
//   },

//   _select: function(e, ui) {
//     $('.new_unit_lbl').addClass('hide');
//     var page = this._input.data('page')
//     var unit = ui.item;
//     var square_feet = unit.square_feet == null ? '' : parseInt(unit.square_feet)
//     if(page == 'show'){
//       $("#new_unit_building").removeClass('hide');
//       $("#unit_id").val(unit.id);
//       $("#unit_name").val(unit.name);
//       $("#unit_square_feet").val(square_feet);
//       $("#unit_number_of_bedrooms").val(unit.number_of_bedrooms);
//       $("#unit_number_of_bathrooms").val(unit.number_of_bathrooms);
      
//       if($("#selection_type").val() != 'new'){
//         $("#new_unit_fields").addClass('hide');
//       }

//     }

//     this._input.val(ui.item.name);
//     var unitContri = $("#unit_contribution").val();
//     if(unitContri == 'unit_review' || 
//        unitContri == 'unit_photos' || 
//        unitContri == 'unit_amenities' || 
//        unitContri == 'unit_price_history'){
      
//       if(unitContri == 'unit_review'){
//         href = '/reviews/new'
//         $("#new_unit_building").attr('action', href);
//         $("#new_unit_building").attr('method', 'get');
//       }

//       $("#new_unit_building").removeClass('hide');
      
//       $('.square_feet_help_block').addClass('hidden');
      
//       $("#unit_id").val(unit.id);
//       $("#unit_name").val(unit.name);
//       $("#unit_square_feet").val(square_feet);
//       $("#unit_number_of_bedrooms").val(unit.number_of_bedrooms);
//       $("#unit_number_of_bathrooms").val(unit.number_of_bathrooms);
//       if(unitContri == 'unit_amenities'){
//         href = "/units/"+unit.id+"/edit"
//         $('#search_item_form').attr('action', href);
//       }
//     }
//     return false;
//   },

//   _response: function(event, ui){
//     if(ui.content.length===0){
//       var ul = $("#units-search-no-results");
//       var markup = [
//         '<p class="address"><b>Unit Not Here?</b></p>',
//         'Contribute by<a href="javascript:void(0)" id="add_new_unit"> adding a new unit</a>'
//       ];
      
//       ul_li = $('<li class="no-result-li">').append(markup.join(''));
//       ul.html(ul_li);
//       ul.css({'display': 'block','width': '555px','top': '36px','left': '15px'});
      
//     }
//   }

// };