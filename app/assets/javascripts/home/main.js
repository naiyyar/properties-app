//= require jquery-ui-touch-punch
//= require lightslider
//= require slick.min
//= require location
//= require left_nav
//= require devise
//= require detect_timezone
//= require jquery.detect_timezone
//= require set_timezone
//= require saved_buildings
//= require bootbox.min
//= require jquery.mask.min
//= require mask
//= require find_device
//= require property_card_actions
//= require search_modal
//= require featured_listings
//= require ./search

setTimeout(function(){ 
	$('.alert').slideUp(300);
}, 3000);

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
		var scroll_top = elem.scrollTop;
		var cta_div = $('.cta-buttons.show-mob');
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
		
		
		