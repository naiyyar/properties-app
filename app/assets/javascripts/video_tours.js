$(function(){
	$('.add-tour-form').on('click', function(e){
	  e.preventDefault();
	  var building_id = $(this).data('bid')
	  var category 		= $(this).data('category');
	  var last_form   = $('#'+category[1]+'-form').find('form').last();
	  var sort_index 	= parseInt(last_form.find('.video_tour_sort').val()) + 1;
	  $.ajax({
	    url: '/video_tours/new',
	    type: 'get',
	    dataType: 'script',
	    data: {building_id: building_id, category: category, sort_index: sort_index },
	    success: function(){
	      
	    }
	  });
	});

	$('.remove-fields').on('click', function(){
	  $(this).parent().parent().parent().parent().parent().remove();
	});

	$('#showTour').on('click', function(){
		$('.show-tour-modal').slideDown(200);
	});

	$('.closeTour').click(function(e) {
    e.stopPropagation();
    $('.show-tour-modal').slideUp(200);
  });
	
});