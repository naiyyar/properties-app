$(document).on 'click','#register',(e) ->
	e.preventDefault();
	$('#signup-taba').tab('show');
	$('#signin-taba').parent().removeClass('active');
	$('#signup-taba').parent().addClass('active');

$(document).on 'click','#signin',(e) ->
	e.preventDefault();
	$('#signin-taba').tab('show');
	$('#signup-taba').parent().removeClass('active');
	$('#signin-taba').parent().addClass('active');
