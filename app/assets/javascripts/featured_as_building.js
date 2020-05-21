$(document).on('keyup', '#featured_building_field', function(){
  if($(this).val() == ''){
    setSubmitButtonStatus(true)
  }
});

$(window).load(function(){
  if($('#featured_building_field').val() != ''){
    setSubmitButtonStatus(false)
  }
});

function setSubmitButtonStatus(status){
  var sbmt = $('.featured_building_form input[type="submit"]');
  if(sbmt.length > 0){
    sbmt[0].disabled = status;  
  }
}
var capp = window.capp = {};
var fields = $('#feature_building_as_comp, #featured_building_field, #listing_building_field')

if($(fields).length > 0) {
  capp.asCompBuildings = function() {
    this._input = fields;
    source_url = this._input.data('src');
    this._initAutocomplete();
  };

  capp.asCompBuildings.prototype = {
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
      var full_address = ui.item.building_address;
      //featured_comp form top search field
      if(ui.item.featured_search_type === 'feature_comp_as'){
        if($('#featured_building_building_id').length > 0){
          $('#featured_building_building_id').val(ui.item.id)
          $('#featured_building_field').val(full_address)
        }else if($('#feature_building_as_comp').length > 0){
          $('#feature_building_as_comp').val(full_address)
          $('#featured_comp_building_id').val(ui.item.id)
        }else if($('#listing_building_id').length > 0){
          //For new/edit Listing form
          $('#listing_building_id').val(ui.item.id);
          $('#listing_building_field').val(full_address); //full address
          $('#listing_building_address').val(ui.item.address);
          $('#listing_management_company').val(ui.item.management_company);
          $('#new_listing input[type="submit"]').removeClass('disabled');
        }
      }
      var sbmt = $('.featured_building_form input[type="submit"]');
      if(sbmt.length > 0){
        sbmt[0].disabled = false;  
      }

      if($("ul.ui-autocomplete").is(":visible")) {
        $("ul.ui-autocomplete").hide();
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
}