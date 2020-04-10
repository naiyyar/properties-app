if($('.home-wrapper').length > 0){
  apt_home = {
    loadImages: function() {
      var figure;
      var id;
      var figures = $('.figure');
      
      for(var i = 0; i < figures.length; i++) {
        figure = figures[i];
        Photo.loadDisplayImage(figure.parentNode.parentNode.dataset.bid);
      }
    },

    loadHeroImage: function(url){
      img_tag = '<img src='+url+' style="width: 100%; height: 100%;" />'
      $('#hero-container').prepend(img_tag);
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