fb = {
  loadImages: function() {
    var figure;
    var id;
    var figures = $('.figure');
    
    for(var i = 0; i < figures.length; i++) {
      figure = figures[i];
      loadDisplayImage(figure.parentNode.parentNode.dataset.bid);
    }
  },

  loadFeaturedBuildings: function() {
    $.ajax({
      url: '/load_featured_buildings',
      dataType: 'script',
      type: 'get',
      success: function() {
        fb.loadImages();
      }
    });
  }
}