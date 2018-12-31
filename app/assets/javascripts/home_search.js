window.addEventListener("load", function() {
  $input = $("[data-behavior='autocomplete']")

  var options = {
    getValue: "name",
    url: function(phrase) {
      return "/auto_search.json?term=" + phrase;
    },
    categories: [
      {
        listLocation: "companies",
        header: "<strong>Management Company</strong>",
      },{
        listLocation: "neighborhoods",
        header: "<strong>Neighborhood</strong>",
      },{
        listLocation: "buildings",
        header: "<strong>Building</strong>",
      },{
        listLocation: "zipcodes",
        header: "<strong>Zipcode</strong>",
      },{
        listLocation: "city",
        header: "<strong>City</strong>",
      }
    ],
    list: {
      maxNumberOfElements: 50,
      adjustWidth: false,
      onChooseEvent: function() {
        //OUTPUIT getSelectedItemData(): {name: "Upper East Side, newyork, NY", url: "/neighborhoods/upper-east-side-newyork"}
        var url = $input.getSelectedItemData().url
        $input.val($input.getSelectedItemData().name)
        window.data = $input.getSelectedItemData()
        //Turbolinks.visit(url)
        window.location = url;
      },
      onShowListEvent: function(){
        //console.log('onShowListEvent')
        $('#eac-container-search_term').find('.no-match-link').remove();
        var elemToAppend = '<div class="no-match-link" style="box-shadow: 0px 1px 4px rgba(0,0,0,0.6);">' +
                           '<a href="/buildings/contribute?results=no-matches-found">'+
                           '<b>No matches found - Add Your Building</b></a></div>';
        $('#eac-container-search_term').append(elemToAppend)
      }
    }
  }

  $input.easyAutocomplete(options)
});