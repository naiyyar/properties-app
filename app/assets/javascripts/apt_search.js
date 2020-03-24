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
        var curr_loc = '<a href="'+location_url+'" class="hyper-link location"><span class="fa fa-location-arrow"></span> Current Location</a>';
        $('.ui-autocomplete').prepend("<li class='ui-autocomplete-group curr-location' style='background: #fff; cursor: pointer;' onclick='getLocation()'>"+curr_loc+"</li>");
      },

      _renderItem: function(ul, item) {
        if(item.search_term == undefined){
          search_term = item.value
        }
        else{
          search_term = item.search_term
        }
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
    var ui_autcomplete = $('.ui-autocomplete')
    ui_autcomplete.off('menufocus hover mouseover mouseenter');
    
    $('.search-loader').hide();
    var ul_height = ui_autcomplete.outerHeight() + 42;

    $('#apt-search-form').find('.no-match-link').remove();
    var elemToAppend = '<div class="no-match-link" style="box-shadow: 0px 1px 4px rgba(0,0,0,0.6);">' +
                       '<a href="/buildings/contribute?results=no-matches-found">'+
                       '<b>No matches found - Add Your Building</b></a></div>';
    $('#apt-search-form').append(elemToAppend);

    if(window.innerWidth <= 414 && $('.split-view-seach').length > 0){
      // making full width when on mobile view
      ui_autcomplete.css('width', '100%');
      ui_autcomplete.css('left', '0px');
      $('.no-match-link').css('top',ul_height+'px');
    }else{
      // setting container width
      var search_input_width = this._input.outerWidth();
      ui_autcomplete.css('width', (search_input_width)+'px');
      $('.no-match-link').css('top',(ul_height + 5)+'px');
    }
    $('.no-match-link').css('width', (ui_autcomplete.width()+2)+'px');
    $('#search_term').removeClass('border-bottom-lr-radius');
  },

  _select: function(e, ui) {
    if(ui.item != undefined){
      this._input.val(ui.item.search_term);
      $('.no-match-link').addClass('hidden');
      // Submitting search form
      if(e.keyCode == 13){
        window.location = ui.item.url;
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