$(function(){
	$('.add-tour-form').on('click', function(e){
	  e.preventDefault();
	  var object_id   = $(this).data('bid')
	  var object_type = $(this).data('type')
	  var category 		= $(this).data('category');
	  var last_form   = $('#'+category+'-form').find('form').last();
	  var sort_index 	= parseInt(last_form.find('.video_tour_sort').val()) + 1;
	  $.ajax({
	    url: '/video_tours/new',
	    type: 'get',
	    dataType: 'script',
	    data: { 
				tourable_id: object_id, 
				tourable_type: object_type, 
				category: category, 
				sort_index: sort_index 
			},
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