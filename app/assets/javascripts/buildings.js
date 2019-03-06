var search_type = '';
var noMatchElemToAppend = '<div class="no-match-link" style="top: 0px; width: 333px;">' +
                      '<span class="address">' +
                        '<b>Building Not Here?</b>' +
                      '</span>' +
                      '<a class="add_new_building" href="javascript:void(0);" id="add_new_building">' +
                        '<b> Add Your Building</b>' +
                      '</a>'
                    '</div>';
app.buildings = function() {
  this._input = $('#buildings-search-txt');
  source_url = $('#buildings-search-txt').data('src');
  if(source_url == undefined){
    source_url = '/buildings/contribute'
  }
  this._initAutocomplete();
};

app.buildings.prototype = {
  _initAutocomplete: function() {
    this._input
      .autocomplete({
        source: source_url,
        prependTo: '#buildings-search-results',
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
    //console.log($('ul.ui-autocomplete'))
    //console.log($('ul.ui-autocomplete').children().length)
    // if($(".no-match-link").hasClass('hidden')){
    //   $(".no-match-link").removeClass('hidden');
    // }
  },

  _open: function(event, ui) {
    this._input.removeClass('loader');
    console.log('open')
    var ul_height = $('ul.ui-autocomplete').outerHeight();
    var search_input_width = this._input.outerWidth();
    $('.ui-autocomplete').css('width', search_input_width+'px');
    if(search_type != 'companies'){
      $('#buildings-search-results').html(noMatchElemToAppend);
      $('.no-match-link').css('top',ul_height+'px');
      $('.no-match-link').css('width', search_input_width+'px');
    }
    
  },

  _render: function(ul, item) {
    search_type = item.search_type
    console.log('render')
    $("#buildings-search-no-results").css('display','none');
    if($(".no-match-link").hasClass('hidden')){
      $(".no-match-link").removeClass('hidden');
    }
    var building_name = ''
    if(item.building_name == '' || item.building_name == undefined){
      building_name = item.building_street_address;
    }else{
      building_name = item.building_name;
    }
    var markup = [];
    if(item.value != 'No matches found'){
      markup.push('<p class="address"><b>'+item.building_street_address+', '+item.city+', '+item.state+' '+item.zipcode+'</b></p>',
        '<small class="building_name">'+building_name+'</small>');
    }else{
      //console.log('no-match-link')
    }
    
    return $('<li>')
      .append(markup.join(''))
      .appendTo(ul);
  },

  _select: function(e, ui) {
    $('#units-search-txt').val('');
    if(!$('.no-match-link').hasClass('hidden')){
      $('.no-match-link').addClass('hidden');
    }
    
    $("#new_unit_building").addClass('hide');
    $("#search_item_form").find('#next_btn').removeClass('disabled')
    
    if($('.no-result-li').length == 1){
      $('.no-result-li').remove();
    }
    $('#next_to_review_btn').remove();

    //new app.units(ui.item.id);
    
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

    $('#home-search-btn').click();
    if($("ul.ui-autocomplete").is(":visible")) {
      $("ul.ui-autocomplete").hide();
    }
    
    //when adding buildings to management company or adding buikding as featured comp
    var item = '';
    //$('#managed_building_id').val(ui.item.id)
    if(ui.item.building_name != '' && ui.item.building_name != null){
      item = ui.item.building_name;
    }else{
      item = ui.item.building_street_address;
    }
    $('.buttonsWrapper').append('<a href="#" class="btn btn-success">'+item+'</a>');
    if($('#managed_building_id').length > 0){
      $('.management-company-form').append('<input type="hidden" name="managed_building_ids[]" id="managed_building_id" class="form-control" value="'+ui.item.id+'">');
      this._input.val('');
    }else if ($('#comparable_building_ids').length > 0){
      $('.management-company-form').append('<input type="hidden" name="comparable_building_ids[]" id="comparable_building_ids" class="form-control" value="'+ui.item.id+'">');
      this._input.val('');
    }

    return false;
  },

  _close: function(){
    //Hiding no match found - add new building link
     if(!$("ul.ui-autocomplete").is(":visible")) {
        $("ul.ui-autocomplete").show();
      }
      else{
        if(!$('.no-match-link').hasClass('hidden')){
          setTimeout(function(){ $('.no-match-link').addClass('hidden') }, 400);
        }
      }
  },

  // _response: function(event, ui){
         
  //   if(ui.content.length === 0){
  //     this._input.removeClass('loader');
  //     var ul = $("#buildings-search-no-results");
  //     // no_match_text = '<div class="no-match-link hidden">\
  //     //                   <span class="address"><b>Building Not Here?</b></span>\ 
  //     //                   <a href="javascript:void(0);" id="add_new_building" class="add_new_building"> Add Your Building</a>\
  //     //                 </div>'
      
  //     var markup = [
  //       '<span class="address"><b>Building Not Here?</b></span>',
  //       '<a href="javascript:void(0)" id="add_new_building" class="add_new_building"> <b>Add Your Building</b></a>'
  //     ];
  //     var search_field_width = $('#buildings-search-txt').width()+30;
  //     ul_li = $('<li class="ui-menu-item no-result-li">').append(markup.join(''));
  //     ul.html(ul_li);
  //     ul.css({'display': 'block','width': search_field_width+'px','top': '36px','left': '15px','padding':'0px'});
      
  //   }
  // }

};