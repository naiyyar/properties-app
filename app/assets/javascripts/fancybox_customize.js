$('.fancybox').fancybox({
  padding: 0,
  fitToView: false,
  modal: false,
  helpers: {
    buttons: {},
    overlay: {
      opacity: 0.5,  
      css: {'background-color': '#111'} 
    }  
  },
  beforeShow: function () {
    this.width = 1000;
    this.height = 550;
  },
  afterLoad: function(){
    data = this.element.data()
    name = data.imageable
    var image_src = this.element.attr('href')
    var description = "<div class='links'> \
                      <img src="+image_src+" class='overlay-image' />"+"<b>"+ name +"</b>"+"</div>"
    $('.fancybox-overlay').append(description);
  }
  // nextEffect: 'fade',
  // prevEffect: 'fade'
});