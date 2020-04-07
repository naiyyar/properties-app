$(document).on 'click', '.add_new_building',(e) ->
	e.preventDefault();
	search_value = $('#buildings-search-txt').val()
	if(search_value == '')
		$('#buildings-search-txt').parent().addClass('has-error')
	else
		$("#search-form").addClass('hide')
		$("#new_building").removeClass('hide')
		$('#building_building_street_address').val(search_value)

$(document).on 'click', "input[name='contribute_to']",(e) ->
	# hiding Building Not Here? li
	if($(".search-no-result li").length != 0)
		$(".search-no-result li").hide()

	#adding error class if submitting without selecting a building
	if($('#buildings-search-txt').parent().hasClass('has-error'))
		$('#buildings-search-txt').parent().removeClass('has-error')

$(document).on 'click', '#building_deposit_free',(e) ->
	showHideAmenitiesInfoField($('#building_deposit_free_company'))

$(document).on 'click', '#elevator',(e) ->
	showHideAmenitiesInfoField($('#building_elevator'))

@showHideAmenitiesInfoField = (elem) ->
	elem.toggleClass('hide')
	if(elem.hasClass('hide'))
		elem.val('')
		elem.removeAttr('required')
	else
		elem.attr('required', 'required')

$(document).on 'click', '.reviewer_type',(e) ->
	id = $(this).children().attr('id')
	label_year_from = $(".start_year_at_residence")
	label_year_to = $(".end_year_in_residence")

	element_year_to = $('#review_resident_to')
	element_year_from = $('#review_resident_from')

	# when current is selected... Removing default current year from Resident To
	$('#review_resident_to option:eq(1)').prop('selected', false).removeClass('hidden')
	
	if(id == 'visitor')
		label_year_from.addClass('hide')
		label_year_to.addClass('hide')
		
		#removing validation rules
		element_year_from.rules('remove', 'required')
		element_year_to.rules('remove', 'required')

	else if(id == 'former_tenant') 
		label_year_from.removeClass('hide')
		label_year_to.removeClass('hide')
		element_year_from.rules('add', 'required')
		element_year_to.rules('add', 'required')
	else
		$('#review_resident_to option:eq(1)').prop('selected', true)
		label_year_to.addClass('hide')
		label_year_from.removeClass('hide')
		element_year_from.rules('add', 'required')
		element_year_to.rules('remove', 'required')

#preventing enter key to submit form 
$(document).on 'keypress', 'form',(e) ->
	if e.keyCode == 13 && e.target.tagName.toLowerCase() != 'textarea'
		return false
