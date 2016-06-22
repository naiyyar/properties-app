$(document).on 'click', '#add_new_building',(e) ->
	e.preventDefault();
	$(".buildings-search").hide();
	$("#new_building").removeClass('hide');

$(document).on 'click', "input[name='contribute_to']",(e) ->
	$("#contribution").val(this.value)