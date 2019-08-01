$(document).on 'click', '.apple-switch.listing', (e) ->
	if(!$(this).is(':checked'))
		changeListingStatus(false, $(this))
	else
		changeListingStatus(true, $(this))


changeListingStatus = (status, elem) ->
	lid = elem.data('lid')
	$.ajax
		url: '/listings/'+lid
		dataType: 'json'
		type: 'put'
		beforeSend: (xhr) -> 
			xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
		data: { listing: { active: status } }
		success: (response) ->
			console.log(response)

#==============================
#Form submit confirm message
#==============================
$(document).on 'submit', 'form#active_on_action_form, form#active_off_action_form, form#delete_action_form', (e) ->
	message = ''
	form_id = $(this).attr('id')
	if form_id == 'active_on_action_form'
		message = 'Are sure you want to make selected rows Active?'
	else if form_id == 'active_off_action_form'
		message = 'Are sure you want to make selected rows Inactive?'
	else 
		message = 'Are sure you want to delete all selected rows?'
	
	c = confirm(message)
	if !c
		removeDisbaleFromSubmitButton($(this))
	return c

#==============================
#on confirm box cancel click it's adding disabled atrribute to submit form button
#==============================
removeDisbaleFromSubmitButton=(elem)->
	elem.find("input[type='submit']").removeAttr('disabled')


#Errors
#
$(document).on 'click', '.import-errors a.close',(e) ->
	$(this).parent().remove();

