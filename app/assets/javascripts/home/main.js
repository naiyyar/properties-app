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

	lazyLoadThumbImages: function(id){
		$.ajax({
			url: '/buildings/'+id+'/load_thumb_images',
			dataType: 'script',
			type: 'get',
			success: function(){
				//console.log('thumb images loaded')
			}
		})
	}

};

