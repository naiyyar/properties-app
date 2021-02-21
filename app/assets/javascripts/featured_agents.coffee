#Changing featured agent status
#
$(document).on 'click', '.apple-switch.featured-agent', (e) ->
	$this = $(this)
	field_type = $this.data('field')
	if(!$this.is(':checked'))
		if field_type != undefined && field_type == 'renew'
			setPaymentRenewStatus(false, $this)
		else
			changeFeaturedAgentStatus(false, $this)
	else
		if $this.data('fbby') == 'manager' && $this.data('expired') == 'expired'
			window.location.href = $this.data('billingurl')
		else
			if field_type != undefined && field_type == 'renew'
				setPaymentRenewStatus(true, $this)
			else
				changeFeaturedAgentStatus(true, $this)


changeFeaturedAgentStatus = (status, elem) ->
	agent_id = elem.data('agentid')
	$.ajax
		url: '/featured_agents/'+agent_id
		dataType: 'json'
		type: 'put'
		beforeSend: (xhr) -> 
			xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
		data: { featured_agent: { active: status } }
		success: (response) ->
			console.log(response)

setPaymentRenewStatus = (status, elem) ->
	agent_id = elem.data('agentid')
	$.ajax
		url: '/featured_agents/'+agent_id
		dataType: 'json'
		type: 'put'
		beforeSend: (xhr) -> 
			xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
		data: { featured_agent: { renew: status } }
		success: (response) ->
			console.log(response)