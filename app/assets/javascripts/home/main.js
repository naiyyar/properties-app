//= require jquery-ui.min
//= require jquery-ui-touch-punch
//= require bootstrap/modal
//= require bootstrap/dropdown
//= require lightslider
//= require slick.min
//= require location
//= require left_nav
//= require devise
//= require detect_timezone
//= require jquery.detect_timezone
//= require saved_buildings
//= require bootbox.min
//= require jquery.mask.min
//= require mask
//= require ./search

setTimeout(function(){ 
	$('.alert').slideUp(300);
}, 3000);

//finding device type
var mobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
const Device = {
	type: { mobile: mobile}
};

Card = {
	loadDisplayImageAndCTALinks: function(building_id){
	  var fig_elem 			= $("#figure"+building_id);
	  var cta_elem 			= $("#cta-links"+building_id);
	  var filter_params = $('#filter-params').data('filterparams');
	  
	  $.ajax({
	    url: '/get_images',
	    dataType: 'json',
	    type: 'get',
	    data: { building_id: building_id, filter_params: filter_params },
	    success: function(response){
	      fig_elem.html(response.html);
	      Card.initLightSlider(fig_elem.find('.gallery'), Card.enableTouch(), 1);
	      cta_elem.html(response.cta_html);
	    }
	  });
	},

	enableTouch: function(){
		var enable_touch = true;
		if($('#featured-buildings-section').length > 0 || $('.building-detail-card.featured-comps').length > 0){
			enable_touch = false;
		}
		return enable_touch;
	},

	initLightSlider: function(elem, enable_touch, items){
	  elem.lightSlider({
	    item: items,
	    slideMargin: 0,
	    loop: true,
	    enableDrag: enable_touch,
	    enableTouch: enable_touch,
	    onBeforeSlide: function(el) {
	       show_count_elem = el.parent().parent().prev();
	       current_elem = show_count_elem.find('.current');
	       current_elem.text(el.getCurrentSlideCount);
	     }
	  });
	},

	initSlick: function(slides_to_show){
		var show_arrows = (slides_to_show == 2 ? true : false);
		var centered 		= !show_arrows;
		$(".center").slick({
			dots: false,
			infinite: true,
			centerMode: centered,
			slidesToShow: slides_to_show,
			slidesToScroll: slides_to_show,
			arrows: show_arrows
		});
	},

	loadFeaturedAgentImagesAndCTALinks: function(agent_id){
		var fig_elem = $("#figure"+agent_id);
		var cta_elem = $("#agent-cta-links"+agent_id);
	  $.ajax({
	    url: '/featured_agents/get_images',
	    dataType: 'json',
	    type: 'get',
	    data: { id: agent_id },
	    success: function(response){
	      fig_elem.html(response.html);
	      Card.initLightSlider(fig_elem.find('.gallery'), Card.enableTouch());
	      cta_elem.html(response.cta_html);
	    }
	  });
	}
};

Transparentcity = {
	initFancybox: function(selector){
		$().fancybox({
			selector: selector,
			backFocus: false,
			buttons: ['thumbs', 'close']
		});
	},

	loadTourVideos: function(elem, ids){
		var $this  = elem;
		var cat 	 = $this.dataset.category;
		var loader = $('.loader-'+cat);
		loader.show();
		$.ajax({
			url: '/video_tours',
			dataType: 'script',
			type: 'get',
			data: { ids: ids, category: cat },
			success: function(){
				loader.hide();
			}
		})
	},
	showHideCTALinks: function(elem){
		var $this  		 = elem;
		var scroll_top = $this.scrollTop;
		var cta_div 	 = $('.cta-buttons.show-mob');
		if(scroll_top >= 685 ){
			cta_div.show();
		}else{
			cta_div.hide();
		}
	},

	lazyLoadShowPageContent: function(id){
		$.ajax({
			url: '/buildings/'+id+'/lazy_load_content',
			dataType: 'script',
			type: 'get',
			success: function(){
				//console.log('thumb images loaded')
			}
		})
	}

};

//

$('.btn').click(function() {
  if ($(this).is('[data-toggle-class]')) {
    $(this).toggleClass('active ' + $(this).attr('data-toggle-class'));
  }
});
if($('.progress-bar[data-toggle="tooltip"]').length > 0){
    $('.progress-bar[data-toggle="tooltip"]').tooltip();
}
if($('.tooltipsContainer .btn').length > 0){
    $('.tooltipsContainer .btn').tooltip();
}
if($('#datepicker').length > 0){
    $('#datepicker').datepicker();
}

// clear text search
$('.clearSearchText').click(function(){
    $("#search_term").val('');
});

// search box text seletion on click
$("#apt-search-txt-searchpage, #search_term").click(function () {
  $(this).select();
});

//
// For mobile neighborhoods dropdown toggle
$('.dropdown-toggle-neighborhoods, .closeHoods').click(function(e) {
  $('.popular-neighborhoods').slideToggle(200, 'linear', function(){
    var elem             = $('#wrapper.screen-sm');
    var toggleable_class = 'no-touch-scroll'
    $(this).is(':hidden') ? elem.removeClass(toggleable_class) : elem.addClass(toggleable_class);
  });
});


// setting timezone
$('.user_time_zone').set_timezone(); 
const timezone = $('.user_time_zone').val(); 
// setting in cookies to access using helper method on application controller
function setCookie(name, value) {
  var expires = new Date()
  expires.setTime(expires.getTime() + (24 * 60 * 60 * 1000))
  document.cookie = name + '=' + value + ';expires=' + expires.toUTCString()
}

setCookie("timezone", timezone)

