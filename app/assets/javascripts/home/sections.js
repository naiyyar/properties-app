if($('.home-wrapper').length > 0){
  apt_home = {
    loadImages: function() {
      var figure;
      var id;
      var figures = $('.figure');
      
      for(var i = 0; i < figures.length; i++) {
        figure = figures[i];
        Card.loadDisplayImage(figure.parentNode.parentNode.dataset.bid);
      }
    },

    loadFeaturedBuildings: function() {
      $.ajax({
        url: '/load_featured_buildings',
        dataType: 'script',
        type: 'get',
        success: function() {
          apt_home.loadImages();
        }
      });
    }
  }
}