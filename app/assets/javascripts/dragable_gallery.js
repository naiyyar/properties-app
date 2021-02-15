$(document).ready(function(){
  var gallery = document.getElementById('gallery');
  if(gallery){
    new Sortable(gallery, {
      swapThreshold: 0.59,
      animation: 150,
      ghostClass: 'gray-background',
      //swap: true, // Enable swap plugin
      //swapClass: 'highlight'
    });
  }
});