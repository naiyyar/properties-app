$(document).ready(function(){
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
      onChooseEvent: function() {
        console.log($input)
        var url = $input.getSelectedItemData().url
        $input.val("")
        //Turbolinks.visit(url)
        window.location = url;
      }
    }
  }

  $input.easyAutocomplete(options)
});