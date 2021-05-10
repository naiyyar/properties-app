Card = {
	loadDisplayImageAndCTALinks: function(elem, type){
		var prop_id = elem.data('bid');
    var type = elem.data('proptype');
	  var fig_elem = $("#figure"+prop_id);
	  var cta_elem = $("#cta-links"+prop_id);
	  var filter_params = $('#filter-params').data('filterparams');
	  var property_type = type || 'Building';
	  $.ajax({
	    url: '/get_images',
	    dataType: 'json',
	    type: 'get',
	    data: { object_id: prop_id, filter_params: filter_params, property_type: type },
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
		var centered = !show_arrows;
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
	      Card.initLightSlider(fig_elem.find('.gallery'), Card.enableTouch(), 1);
	      cta_elem.html(response.cta_html);
	    }
	  });
	}
};