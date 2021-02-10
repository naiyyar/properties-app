#Changing featured Listing status
#
$(document).on 'click', '.apple-switch.featured-listing', (e) ->
	e.preventDefault
	$this = $(this)
	field_type = $this.data('field')
	if(!$this.is(':checked'))
		if field_type != undefined && field_type == 'renew'
			setPaymentRenewStatus(false, $this)
		else
			changeFeaturedListingStatus(false, $this)
	else
		if $this.data('fbby') == 'manager' && $this.data('expired') == 'expired'
			window.location.href = $this.data('billingurl')
		else
			if field_type != undefined && field_type == 'renew'
				setPaymentRenewStatus(true, $this)
			else
				changeFeaturedListingStatus(true, $this)


changeFeaturedListingStatus = (status, elem) ->
	id = elem.data('fbid')
	$.ajax
		url: '/featured_listings/'+id
		dataType: 'json'
		type: 'put'
		beforeSend: (xhr) -> 
			xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
		data: { featured_listing: { active: status } }
		success: (response) ->
			console.log(response)

setPaymentRenewStatus = (status, elem) ->
	id = elem.data('fbid')
	$.ajax
		url: '/featured_listings/'+id
		dataType: 'json'
		type: 'put'
		beforeSend: (xhr) -> 
			xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
		data: { featured_listing: { renew: status } }
		success: (response) ->
			console.log(response)