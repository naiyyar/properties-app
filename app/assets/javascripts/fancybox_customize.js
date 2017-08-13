$(document).ready(function () {
  $('.fancybox').fancybox({
    padding: 0,
    fitToView: true,
    maxWidth: "100%",
    modal: false,
    helpers: {
      buttons: {},
      // overlay: {
      //   opacity: 0.5,  
      //   css: {'background-color': '#111'} 
      // }  
    },
    // beforeShow: function () {
    //   this.width = 1000;
    //   this.height = 550;
    // },
    afterLoad: function(){
      data = this.element.data()
      name = data.imageable
      var image_src = this.element.attr('href')
      var description = "<div class='links hidden'> \
                        <img src="+image_src+" class='overlay-image' />"+"<b>"+ name +"</b>"+"</div>"
      $('.fancybox-overlay').append(description);
    }
    // nextEffect: 'fade',
    // prevEffect: 'fade'
  });
})
