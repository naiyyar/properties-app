$(document).ready(function () {
  
  if(mobile){
    var c, currentScrollTop = 0,
        header = $('.header2');

    $('.searched-properties').scroll(function () {
      var a = $('.searched-properties').scrollTop();
      var b = header.height();
     
      currentScrollTop = a;
     
      if (c < currentScrollTop && a > b + b) {
        header.slideUp('slow');
      } else if (c > currentScrollTop && !(a <= b)) {
        header.slideDown('slow');
      }
      c = currentScrollTop;
    });
  }
});