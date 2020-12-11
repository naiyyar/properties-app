var app = window.app = {};

app.apartments = function() {
  this._input = $('#search_term');
  this._initAutocomplete();
};

app.apartments.prototype = {
  _initAutocomplete: function() {
    $.widget( "custom.catcomplete", $.ui.autocomplete, {
      _create: function() {
        this._super();
        this.widget().menu( "option", "items", "> :not(.ui-autocomplete-group)" );
      },
      _renderMenu: function( ul, items ) {
        var that = this,
          currentCategory = "";
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
        var curr_loc = '<a href="'+location_url+'" class="hyper-link location" style="display: block;" onclick="getLocation()"><span class="fa fa-location-arrow"></span> Current Location</a>';
        $('.ui-autocomplete').prepend("<li class='ui-autocomplete-group curr-location' style='background: #fff; cursor: pointer;'>"+curr_loc+"</li>");
      },

      _renderItem: function(ul, item) {
        search_term = (item.search_term == undefined ? item.value : item.search_term)
        
        $('#search_term').removeClass('loader');
        
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

    this._input.catcomplete({
      source: '/auto_search.json',
      appendTo: '#apt-search-results',
      select: $.proxy(this._select, this),
      open: $.proxy(this._open, this),
      search: $.proxy(this._search, this),
      close: $.proxy(this._close, this)
    });
  },

  _search: function(e,ui){
    $('.search-loader').show();
  },

  _open: function(event, ui) {
    // Fix for double tap on ios devices
    var ui_autcomplete  = $('.ui-autocomplete');
    var no_match_link;
    var ul_height       = ui_autcomplete.outerHeight() + 42;
    var elemToAppend    = '';

    ui_autcomplete.off('menufocus hover mouseover mouseenter');
    $('.search-loader').hide();
    $('#apt-search-form, #search-modal').find('.no-match-link').remove();
    
    elemToAppend =  '<div class="no-match-link" style="box-shadow: 0px 1px 4px rgba(0,0,0,0.6);">' +
                    '<a href="/buildings/contribute?results=no-matches-found">'+
                    '<b>No matches found - Add Your Building</b></a></div>';
    if(mobile){
      $('#search-modal').append(elemToAppend);
    }
    else{
      $('#apt-search-form').append(elemToAppend);
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
        var search_input_width = this._input.outerWidth();
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
      $('#search_term').removeClass('border-bottom-lr-radius');
    }
    
  },

  _select: function(e, ui) {
    var item = ui.item;
    if(item != undefined){
      this._input.val(item.search_term);
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
  }

};