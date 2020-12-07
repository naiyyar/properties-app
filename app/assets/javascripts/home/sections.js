apt_home = {
  loadImages: function() {
    var figure;
    var id;
    var figures = $('.figure');
    
    for(var i = 0; i < figures.length; i++) {
      figure = figures[i];
      Card.loadDisplayImageAndCTALinks(figure.parentNode.parentNode.dataset.bid);
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

window.onload = function() {
  if($('.home-wrapper').length > 0){
    apt_home.loadFeaturedBuildings();
  }

  $('#search-input-placeholder').on('click', function(){
    $('#search-modal').show();
  });

  $('.fa-arrow-left').on('click', function(){
    $('#search-modal').hide();
  })
}