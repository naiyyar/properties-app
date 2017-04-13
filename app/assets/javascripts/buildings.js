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
        response: $.proxy(this._response, this),
        open: $.proxy(this._open, this)
      })
      .autocomplete('instance')._renderItem = $.proxy(this._render, this);
  },

  _open: function(event, ui) {
    $('.ui-autocomplete').append('<li class="ui-menu-item building_link_li"><span class="address"><b>Building Not Here?</b></span> <a href="javascript:void(0)" id="add_new_building" class="add_new_building"> Add a building</a></li>');
  },

  _render: function(ul, item) {
    $("#buildings-search-no-results").css('display','none');
    building_name = ''
    if(item.building_name == '' || item.building_name == undefined){
      building_name = item.building_street_address;
    }else{
      building_name = item.building_name;
    }
    var markup = [
      '<p class="address"><b>'+item.building_street_address+', '+item.city+', '+item.state+' '+item.zipcode+'</b></p><br/>',
      '<small class="building_name">'+building_name+'</small>'
    ];
    
    return $('<li>')
      .append(markup.join(''))
      .appendTo(ul);
  },

  _select: function(e, ui) {
    $('#units-search-txt').val('');
    
    $("#new_unit_building").addClass('hide');
    $("#search_item_form").find('#next_btn').removeClass('disabled')
    
    if($('.no-result-li').length == 1){
      $('.no-result-li').remove();
    }
    $('#next_to_review_btn').remove();
    
    new app.units(ui.item.id);
    
    this._input.val(ui.item.building_street_address + ', ' + ui.item.city + ', ' + ui.item.state + ' ' + ui.item.zipcode);
    
    $('#zip').val(ui.item.zipcode)
    
    var unitContri = $("#unit_contribution").val();
    
    var contribution_for = $("#contribution").val();
    
    if(contribution_for == 'building_amenities'){
      href = "/buildings/"+ui.item.id+"/edit";
      $('#search_item_form').attr('action', href);
    }

    //Adding and removing next btn with next page link
    if(contribution_for == 'unit_review' 
      || contribution_for == 'unit_photos' 
      || contribution_for == 'unit_amenities' 
      || contribution_for == 'unit_price_history'){

      if(!$('#next_btn').hasClass('hidden')){
        $('#next_btn').addClass('hidden');
      }
    }
    else{
      if($('#next_btn').hasClass('hidden')){
        $('#next_btn').removeClass('hidden');
      }
    }

    if(unitContri == 'unit_review' 
      || unitContri == 'unit_photos' 
      || unitContri == 'unit_amenities' 
      || unitContri == 'unit_price_history'){
      
      $("#new_unit_building #building_building_street_address").val(ui.item.building_street_address);
      $('#new_unit_building #building_zipcode').val(ui.item.zipcode);
      $("#new_unit_building #building_building_name").val(ui.item.building_name);
      $(".unit-search").removeAttr('readonly');
      if(!$("#unit_name").parent().parent().hasClass('hide')){
        $("#unit_name").parent().parent().addClass('hide');
      }
    }
    return false;
  },

  _response: function(event, ui){
         
    if(ui.content.length === 0){
      var ul = $("#buildings-search-no-results");
      var markup = [
        '<p class="address"><b>Building Not Here?</b></p>',
        'Contribute by<a href="javascript:void(0)" id="add_new_building" class="add_new_building"> adding a new building</a>'
      ];
      
      ul_li = $('<li class="ui-menu-item no-result-li">').append(markup.join(''));
      ul.html(ul_li);
      ul.css({'display': 'block','width': '555px','top': '36px','left': '15px'});
      
    }
  }

};