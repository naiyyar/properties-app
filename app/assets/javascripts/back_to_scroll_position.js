var scroll_pos = 0;
function AddScroller(elem) {
	var link = $(elem).parent()[0];
  link.addEventListener("click", function(e) {
  	scroll_pos = document.getElementsByClassName("searched-properties")[0].scrollTop;
  	localStorage.setItem('scroll_pos', scroll_pos);
  }, false);
};

function setupSrollHistory() {
	var figures = $('.figure');
	for(var i = 0; i < figures.length; i++){
		AddScroller(figures[i]);	
	};
};

function resetScrollPos(){
  console.log('reset')
  setTimeout(function(){
    localStorage.setItem('scroll_pos', 0);
  }, 3000);
};

window.onload = function() {
  scroll_pos = parseInt(localStorage.getItem('scroll_pos'));
  if(scroll_pos > 10){
    var cnt = $('.content');
    if(cnt.hasClass('homesearch')){
  	  $('.searched-properties').scrollTop(scroll_pos);
  	  resetScrollPos();
    }else if(!cnt.hasClass('buildingsshow')){
      resetScrollPos();
    }
  }
  setupSrollHistory();
};