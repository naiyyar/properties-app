$(document).on 'click', '.apple-switch.building', (e) ->
	status = $(this).is(':checked')
	ftype  = $(this).data('ftype')
	
	$.ajax
		url: '/buildings/'+$(this).data('fbid')
		dataType: 'json'
		type: 'put'
		beforeSend: (xhr) -> 
			xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
		data: { building: buildingParams(status, ftype) }
		success: (response) ->
			console.log(response)

$(document).on 'change', '.b-nb-dropdown', ->
	$('#selected_manually').val('manually')

#
$(document).on 'click', '.apple-switch.company', (e) ->
	el = $(this)
	field = el.data('fieldtype')
	id = el.data('companyid');
	check_status = $(this).is(':checked')
	
	$.ajax
		url: '/management_companies/'+id+'/set_availability_link'
		dataType: 'json'
		type: 'get'
		data: buildingParams(check_status, field)
		success: (response) ->
			console.log(response)


@buildingParams = (status, ftype) ->
	if(ftype == 'web_url' || ftype == 'website')
		params = { active_web:  status }
	else if(ftype == 'application_link')
		params = { show_application_link: status }
	else if(ftype == 'schedule_tour')
		params = { schedule_tour_active: status }
	else if(ftype == 'apply')
		params = { apply_link: status }
	else
		params = { active_email: status }

	return params