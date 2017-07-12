$(document).on 'click', '#submit_rev1iew',(e) ->
	score = $("input[name='score']").val()
	submit = false

	if(score == '')
		e.preventDefault();
		$(".rating-not-selected").removeClass('hide')
		submit = false
	else
		$(".rating-not-selected").addClass('hide')
		submit = true

	return submit