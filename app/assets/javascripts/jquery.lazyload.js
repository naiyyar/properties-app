$(document).ready(function() {
  //setTimeout(function(){
  $.ajax({
    url: '/lazy_load_content',
    type: 'get',
    dataType: 'script'
  });
  //}, 2000);
});