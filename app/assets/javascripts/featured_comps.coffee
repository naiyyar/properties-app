$(document).on 'click', '.apple-switch.featured_comps', (e) ->
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
$(document).on 'click', '.apple-switch.featured-building', (e) ->
	$this = $(this)
	field_type = $this.data('field')
	if(!$this.is(':checked'))
		if field_type != undefined && field_type == 'renew'
			setPaymentRenewStatus(false, $this)
		else
			changeFeaturedBuildingStatus(false, $this)
	else
		if $this.data('fbby') == 'manager' && $this.data('expired') == 'expired'
			window.location.href = $this.data('billingurl')
		else
			if field_type != undefined && field_type == 'renew'
				setPaymentRenewStatus(true, $this)
			else
				changeFeaturedBuildingStatus(true, $this)


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

setPaymentRenewStatus = (status, elem) ->
	fb_id = elem.data('fbid')
	$.ajax
		url: '/featured_buildings/'+fb_id
		dataType: 'json'
		type: 'put'
		beforeSend: (xhr) -> 
			xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
		data: { featured_building: { renew: status } }
		success: (response) ->
			console.log(response)