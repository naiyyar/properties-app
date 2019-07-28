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
#Listing data table tr selection script
#===============================

selectedRowIds = []
$(document).on 'click', '.listing', (e) ->
	selected_row = $(this).parent().parent().parent().parent();
	listing_id = $(selected_row).data('id')
	if($(this).is(':checked'))
		selected_row.addClass('selected')
		selectedRowIds.push(listing_id)
		appendIdsContainerInputToForms(listing_id)
	else
		selectedRowIds = selectedRowIds.filter((x) => x != listing_id)
		selected_row.removeClass('selected')
		removeIdsContainerInputToForms(listing_id)
	#$('.selected_ids').val(selectedRowIds)
	setListingActionButtonsStatus(e)
	

setListingActionButtonsStatus = (e) ->
	actions = $('.listing-actions')
	if $('.dataTable').find('tr.selected').length > 0
		actions.show(300)
	else
		actions.hide(300)

appendIdsContainerInputToForms=(id)->
	inputToAppend = '<input type="hidden" name="selected_ids[]" id="selected_ids_on" class="selected_ids selected_ids_'+id+'" value="'+id+'">'
	$('#active_on_action_form').append(inputToAppend)
	$('#active_off_action_form').append(inputToAppend)
	$('#delete_action_form').append(inputToAppend)

removeIdsContainerInputToForms=(id)->
	$('.selected_ids_'+id).remove();

#==============================
#Form submit confirm message
#==============================

$(document).on 'submit', 'form#active_on_action_form, form#active_off_action_form, form#delete_action_form', (e) ->
	message = ''
	form_id = $(this).attr('id')
	if form_id == 'active_on_action_form'
		message = 'Are sure you want to make selected rows Active?'
	else if form_id == 'active_off_action_form'
		message = 'Are sure you want to make selected rows Non Active?'
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

