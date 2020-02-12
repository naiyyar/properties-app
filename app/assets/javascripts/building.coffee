$(document).on 'click', '.apple-switch.building', (e) ->
	status = $(this).is(':checked')
	if($(this).data('ftype') == 'web_url')
		params = { active_web:  status }
	else if($(this).data('ftype') == 'application_link')
		params = { show_application_link: status }
	else
		params = { active_email: status }
	
	$.ajax
		url: '/buildings/'+$(this).data('fbid')
		dataType: 'json'
		type: 'put'
		beforeSend: (xhr) -> 
			xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
		data: { building: params }
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
	if field == 'website'
		params = { active_web: check_status }
	else if field == 'apply'
		params = { apply_link: check_status }
	else
		params = { active_email: check_status }
	
	$.ajax
		url: '/management_companies/'+id+'/set_availability_link'
		dataType: 'json'
		type: 'get'
		data: params
		success: (response) ->
			console.log(response)