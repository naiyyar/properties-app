var app = window.app = {};
LOC_LINK = {
  locationLinkLi: function(_class){
    var curr_loc = '<a href="'+location_url+'" \
                       class="hyper-link location" \
                       style="display: block;" \
                       onclick="getLocation()"> \
                         <span class="fa fa-location-arrow"></span> Current Location</a>';
    var li = "<li class='"+_class+" curr-location' \
                  style='background: #fff; cursor: pointer; padding: 6px 10px !important;border-bottom: 1px solid #eee;'>"+curr_loc+"</li>";

    return li;
  }
}

AutocompleteLI = {
  itemToRender: function(item){
    return "<a style='display: block;' href="+item.desc+">" +
            "<span class='fa fa-history' style='margin-right: 10px; color: #777;'></span>" + item.label + "</a>";
  }
}

prev_search_items = [];
app.apartments = function() {
  $that = this
  $that._input = $('#search_term');
  let prev_searches = JSON.parse(localStorage.getItem('prevSearches'));
  if(prev_searches) {
    for(i = 0; i < prev_searches.length; i++){
      item = prev_searches[i];
      prev_search_items.push({ label: item.search_term, desc: item.url });
    }
  }
  if($that._input.length > 0){
    if(!mobile) {
      $that._initAutocomplete(prev_search_items);
    }
    $that._initCatAutocomplete();
  }
};

app.apartments.prototype = {
  // Autocompalte to show search history results
  _initAutocomplete: function(items){
    $that._input.autocomplete({
      source: items,
      minLength: 0,
      select: function( e, ui ) {
        var item = ui.item;
        $( "#search_term, #search-input-placeholder" ).val( item.label );
        if(item != undefined){
          if(e.keyCode == 13){ window.location = item.desc; }
        }
        return false;
      }
    }).click(function() {
        $that._input.val('');
        $(this).autocomplete("search");
        var historyUi = $('#ui-id-1');
        if(prev_search_items.length > 0){
          $that._input.removeClass('border-bottom-lr-radius');
        }
        historyUi.prepend(LOC_LINK.locationLinkLi('ui-autocomplete-group'));
        if(historyUi.is(':hidden')){
          historyUi.show();
        }
    }).data( "ui-autocomplete" )._renderItem = function( ul, item ) {
         return $( "<li>" )
         .append(AutocompleteLI.itemToRender(item))
         .appendTo( ul );
      }; 
  },
  // CatAutocompalte to show app search results
  _initCatAutocomplete: function() {
    $.widget( "custom.catcomplete", $.ui.autocomplete, {
      _create: function() {
        this._super();
        this.widget().menu( "option", "items", "> :not(.ui-autocomplete-group)" );
      },
      _renderMenu: function( ul, items ) {
        var that = this,
          currentCategory = "",
          ui_elem = ';'
        $.each( items, function( index, item ) {
          var li;
          if(item.category != undefined){
            if ( item.category != currentCategory ) {
              ul.append( "<li class='ui-autocomplete-group'><b>" + item.category + "</b></li>" );
              currentCategory = item.category;
            }
            li = that._renderItemData( ul, item );
            if ( item.category ) {
              li.attr("aria-label", item.category);
            }
          }
        });
        if(mobile){
          ui_elem = $('#ui-id-1');
        }else{
          ui_elem = $('#ui-id-2');
        }
        ui_elem.prepend(LOC_LINK.locationLinkLi('ui-autocomplete-group'));
      },

      _renderItem: function(ul, item) {
        search_term = (item.search_term == undefined ? item.value : item.search_term)
        // Hightliting searched phrase
        search_phrase = item.search_phrase.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&");
        var regexp = new RegExp('(' + search_phrase + ')', 'gi'),
          label = search_term.replace(regexp, '<b>$1</b>');

        var items = ''
        if(search_term != 'No matches found - Add Your Building'){
          if(search_term != undefined){
            items = '<a href='+item.url+'><p>'+ label + '</p></a>';
          }
        }
        
        var markup = [items];
        $('ul.ui-autocomplete').css('left','10');
        return $('<li>')
          .append(markup.join(''))
          .appendTo(ul);
      }
    });

    $that._input.catcomplete({
      source: '/auto_search.json',
      appendTo: '#apt-search-results',
      select: $.proxy(this._select, this),
      open: $.proxy(this._open, this),
      search: $.proxy(this._search, this),
      close: $.proxy(this._close, this)
    });
  },

  _search: function(e, ui){ },

  _open: function(event, ui) {
    // Fix for double tap on ios devices
    var history_ui      = $('#ui-id-1');
    var ui_autcomplete  = mobile ? $('#ui-id-1') : $('#ui-id-2')
    var no_match_link;
    var ul_height       = ui_autcomplete.outerHeight() + 42;
    var elemToAppend    = '';
    ui_autcomplete.off('menufocus hover mouseover mouseenter');
    $('#apt-search-form, #search-modal').find('.no-match-link').remove();
    elemToAppend =  '<div class="no-match-link" style="box-shadow: 0px 1px 4px rgba(0,0,0,0.6);">' +
                    '<a href="/buildings/contribute?results=no-matches-found">'+
                    '<b>No matches found - Add Your Building</b></a></div>';
    if(mobile){
      $('#search-modal').append(elemToAppend);
      history_ul.hide();
    }
    else{
      $('#apt-search-form').append(elemToAppend);
      //if(history_ui.is(':visible')){ history_ui.hide(); }
    }
    no_match_link = $('.no-match-link');
    if(mobile && $('.split-view-seach').length > 0){
      // making full width when on mobile view
      ui_autcomplete.css('width', '100%');
      ui_autcomplete.css('left', '0px');
      no_match_link.css('top', (ul_height + 30)+'px');
    }else{
      // setting container width
      if(mobile){
        ui_autcomplete.css('width', '100%');
        ui_autcomplete.css('left', '0px');
        if($('#search-modal .no-match-link').length > 0){
          no_match_link.css('top',(ul_height + 30)+'px');
        }
      }else{
        var search_input_width = $that._input.outerWidth();
        ui_autcomplete.css('width', (search_input_width)+'px');
        no_match_link.css('top',(ul_height - 3)+'px');
        if($('.home .no-match-link').length > 0){
          no_match_link.css('top',(ul_height + 5)+'px');
        }
      }
    }
    if(mobile){
      $('.no-match-link').css('width', '100%');
    }
    else{
      $('.no-match-link').css('width', (ui_autcomplete.width()+2)+'px');
      $that._input.removeClass('border-bottom-lr-radius');
    }
    return false;
  },

  _select: function(e, ui) {
    var item = ui.item;
    if(item != undefined){
      $that._input.val(item.search_term);
      $('#search-input-placeholder').val(item.search_term);
      $('.no-match-link').addClass('hidden');
      // Submitting search form
      if(e.keyCode == 13){
        window.location = item.url;
      }
    }
    // hiding autocomplete search results
    if($("ul.ui-autocomplete").is(":visible")) {
      $("ul.ui-autocomplete").hide();
      $('#search_term').addClass('border-bottom-lr-radius');
    }
    $('#search-modal').hide();
    this._save_search(ui.item);
    return false;
  },
  
  _close: function(){
    // Hiding no match found - add new building link
    if(!$("ul.ui-autocomplete").is(":visible")) {
      $("ul.ui-autocomplete").show();
    }
    else{
      setTimeout(function(){ $('.no-match-link').addClass('hidden') }, 400);
    }
  },

  _save_search: function(item){
    let search_arr = new Array;
    let prev_searches = JSON.parse(localStorage.getItem('prevSearches'))
    search_arr.push(item);
    if(prev_searches) {
      for(i = 0; i <= prev_searches.length; i++){
        let prev_item = prev_searches[i];
        if(prev_item && item.id != prev_item.id){
          search_arr.push(prev_searches[i]);
        }
      }
    }
    localStorage.setItem('prevSearches', JSON.stringify(search_arr));
  }
};