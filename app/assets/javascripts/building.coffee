$(document).on 'click', '.apple-switch.building', (e) ->
	status = $(this).is(':checked')
	if($(this).data('ftype') == 'web_url')
		params = { active_web:  status }
	else
		params = { active_email: status }
	
	console.log(params)
	$.ajax
		url: '/buildings/'+$(this).data('fbid')
		dataType: 'json'
		type: 'put'
		beforeSend: (xhr) -> 
			xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
		data: { building: params }
		success: (response) ->
			console.log(response)