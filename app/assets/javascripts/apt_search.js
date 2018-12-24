// app.apartments = function() {
//   this._input = $('#search_term');
//   this._initAutocomplete();
// };

// app.apartments.prototype = {
//   _initAutocomplete: function() {
//     $.widget( "custom.catcomplete", $.ui.autocomplete, {
//       _create: function() {
//         this._super();
//         this.widget().menu( "option", "items", "> :not(.ui-autocomplete-group)" );
//       },
//       _renderMenu: function( ul, items ) {
//         var that = this,
//           currentCategory = "";
//         $.each( items, function( index, item ) {
//           var li;
//           if(item.category != undefined){
//             if ( item.category != currentCategory ) {
//               ul.append( "<li class='ui-autocomplete-group'><b>" + item.category + "</b></li>" );
//               currentCategory = item.category;
//             }
//             li = that._renderItemData( ul, item );
//             if ( item.category ) {
//               li.attr("aria-label", item.category);
//             }
//           }
//         });
//       },

//       _renderItem: function(ul, item) {
//         if(item.search_term == undefined){
//           search_term = item.value
//         }
//         else{
//           search_term = item.search_term
//         }
//         $('#search_term').removeClass('loader');
//         var items = ''
//         if(search_term != 'No matches found - Add Your Building'){
//           if(search_term != undefined){
//             items = '<p class="address"><b>' + search_term + '</b></p>';
//           }
//         }
        
//         var markup = [items];
//         $('ul.ui-autocomplete').css('left','10');
//         return $('<li>')
//           .append(markup.join(''))
//           .appendTo(ul);
//       }
//     });

//     this._input.catcomplete({
//       source: '/auto_search.json',
//       appendTo: '#apt-search-results',
//       select: $.proxy(this._select, this),
//       // select: function(event, ui){
//       //   console.log(ui.item)
//       // },
//       open: $.proxy(this._open, this),
//       search: $.proxy(this._search, this),
//       close: $.proxy(this._close, this)
//     });
//   },

//   _search: function(e,ui){
//     this._input.addClass('loader');
//   },

//   _open: function(event, ui) {
//     this._input.removeClass('loader');
//     var ul_height = 0;
//     $.each($('ul.ui-autocomplete'), function(){
//       var height = $(this).height();
//       if(height > 0){
//         ul_height = $(this).height();
//       }
//     });
    
//     if($('.apt-search-text-shared').length >= 1){
//       $('ul.ui-autocomplete').css('width', $('.apt-search-text-shared').width()+20+'px');
//       $('.no-match-link').addClass('no-match-position-left');
//     }else{
//       $('ul.ui-autocomplete').css('width', $('#search_term').width()+80+'px');
//     }
//     $('.no-match-link').css('top',ul_height+'px');
//     $('.no-match-link').removeClass('hidden');
//     $('.no-match-link').css('width',$('ul.ui-autocomplete').width()+2+'px');
//   },

//   _select: function(e, ui) {
//     console.log(ui)
//     if(ui.item != undefined){
//       search_term = ui.item.search_term;
//       this._input.val(search_term);
      
//       url = '';
//       if(ui.item.term_address != undefined){
//         url = '/address/'+ui.item.term_address;
//       }else if(ui.item.management_company_name != undefined){
//         url = '/management_company/'+ui.item.management_company_name;
//       }else if(ui.item.term_zipcode != undefined){
//         url = '/zipcode/'+ui.item.term_zipcode;
//       }else if(ui.item.neighborhoods != undefined){
//         url = '/neighborhoods/'+ui.item.neighborhoods;
//       }
//       else{
//         url = '/city/'+ui.item.term_city;
//       }
    
//       $('.no-match-link').addClass('hidden');
      
//       //Submitting search form
//       window.location = url;
//     }
//     //hiding autocomplete search results
//     if($("ul.ui-autocomplete").is(":visible")) {
//       $("ul.ui-autocomplete").hide();
//     }
//     return false;
//   },
  
//   _close: function(){
//     //Hiding no match found - add new building link
//     if(!$("ul.ui-autocomplete").is(":visible")) {
//       $("ul.ui-autocomplete").show();
//     }
//     else{
//       setTimeout(function(){ $('.no-match-link').addClass('hidden') }, 400);
//     }    
//   }

// };