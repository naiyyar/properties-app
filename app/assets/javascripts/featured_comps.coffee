$(document).on 'click', '.apple-switch', (e) ->
	if(!$(this).is(':checked'))
		changeFeaturedCompStatus(false, $(this))
	else
		changeFeaturedCompStatus(true, $(this))


changeFeaturedCompStatus = (status, elem) ->
	comp_id = elem.data('compid')
	$.ajax
		url: '/featured_comps/'+comp_id
		dataType: 'json'
		type: 'put'
		beforeSend: (xhr) -> 
			xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
		data: {featured_comp: { active: status } }
		success: (response) ->
			console.log(response)


#Changing featured building status
#
$(document).on 'click', '.apple-switch.feature-building', (e) ->
	if(!$(this).is(':checked'))
		changeFeaturedBuildingStatus(false, $(this))
	else
		changeFeaturedBuildingStatus(true, $(this))


changeFeaturedBuildingStatus = (status, elem) ->
	fb_id = elem.data('fbid')
	$.ajax
		url: '/featured_buildings/'+fb_id
		dataType: 'json'
		type: 'put'
		beforeSend: (xhr) -> 
			xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
		data: { featured_building: { active: status } }
		success: (response) ->
			console.log(response)