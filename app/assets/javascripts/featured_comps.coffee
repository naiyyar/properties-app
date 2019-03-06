$(document).on 'click', '.apple-switch',(e) ->
	if(!$(this).is(':checked'))
		changeFeaturedCompStatus(false, $(this))
	else
		changeFeaturedCompStatus(true, $(this))


changeFeaturedCompStatus = (status, elem) ->
	comp_id = elem.data('compid')
	$.ajax
		url: '/featured_comps/'+comp_id+'.json'
		dataType: 'json'
		type: 'PUT'
		data: {featured_comp: { active: status } }
		success: (response) ->
			console.log(response)