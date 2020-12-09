var ready = function(){
	$('#search-input-placeholder').on('click', function(){
    $('#search-modal').css('z-index', '99999').show();
    $('#search_term').focus();
	});

	$('.fa-arrow-left').on('click', function(){
	  $('#search-modal').hide();
	});

	$('#search_term').on('focus', function(){
		$(this).val('');
	});
}

$(document).ready(ready)
$(document).on('page:load', ready)