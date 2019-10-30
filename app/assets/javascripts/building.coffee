$(document).on 'click', '.apple-switch.building', (e) ->
	status = $(this).is(':checked')
	if($(this).data('ftype') == 'web_url')
		params = { active_web:  status }
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
	if field == 'website'
		params = { active_web:  $(this).is(':checked') }
	else
		params = { active_email:  $(this).is(':checked') }
	
	$.ajax
		url: '/management_companies/'+id+'/set_availability_link'
		dataType: 'json'
		type: 'get'
		data: params
		success: (response) ->
			console.log(response)