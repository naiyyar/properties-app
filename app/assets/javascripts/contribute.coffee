$(document).on 'click', '.add_new_building',(e) ->
	e.preventDefault();
	search_value = $('#buildings-search-txt').val()
	if(search_value == '')
		$('#buildings-search-txt').parent().addClass('has-error')
	else
		$("#search-form").addClass('hide')
		$("#new_building").removeClass('hide')
		$('#building_building_street_address').val(search_value)
	
	if($("#units-search-txt").length == 1)
		$("#units-search-txt").remove()

#Adding new unit contribution page
$(document).on 'click', '#add_new_unit',(e) ->
	e.preventDefault()
	$("#selection_type").val('new')
	if($("#new_unit_fields").hasClass('hide'))
		$("#new_unit_fields").removeClass('hide')
	search_value = $('#units-search-txt').val()
	$("#unit_id").val('')
	$("#unit_name").val(search_value)
	$("#unit_square_feet").val('')
	$("#unit_number_of_bedrooms").val('')
	$("#unit_number_of_bathrooms").val('')
	$("#new_unit_building").removeClass('hide')
	if($('.new_unit_lbl').hasClass('hide'))
		$('.new_unit_lbl').removeClass('hide');
	if($('.square_feet_help_block').hasClass('hidden'))
		$('.square_feet_help_block').removeClass('hidden')
		$('.square_feet_help_block').css('visibility', 'hidden');
	$(".unit-search").addClass('hide')
	if($("#unit_name").parent().parent().hasClass('hide'))
		$("#unit_name").parent().parent().removeClass('hide')


$(document).on 'click', "input[name='contribute_to']",(e) ->
	search_input = '<input name="units-search-txt" id="units-search-txt" type="text" class="unit-search form-control" placeholder="Search unit number" readonly="readonly"/>'
	unit_search_text_box = $('.unit-search').find('.form-group').find('input')
	user_id = $("#user_id").val();

	#hiding Building Not Here? li
	if($(".search-no-result li").length != 0)
		$(".search-no-result li").hide()

	#adding error class if submitting without selecting a building
	if($('#buildings-search-txt').parent().hasClass('has-error'))
		$('#buildings-search-txt').parent().removeClass('has-error')

	if(this.value=='unit_review' || this.value=='unit_photos' || this.value=='unit_amenities' || this.value=='unit_price_history')
		if($("#units-search-txt").val() != '')
			$("#units-search-txt").val('')
		#hiding unit form 
		if(!$("#new_unit_building").hasClass('hide'))
			$("#new_unit_building").addClass('hide')
		
		$(".unit-search").removeClass('hide').attr('readonly','readonly');
		$("#next_btn").addClass('hidden')
		$("#next_to_review_btn").remove()
		$("#buildings-search-txt").val('')
		$("#buildings-search-no-results > li.no-result-li").hide()
		$("#unit_contribution").val(this.value)
		if(!$("#new_building").hasClass('hide'))
			$("#new_building").addClass('hide');
		#For new building creation
		$("#contribution").val(this.value)
		$("#new_building_submit").val('Submit')
		if($("#search-form").hasClass('hide'))
			$("#search-form").removeClass('hide')
			$("#buildings-search-txt").val('')
			$(".no-result-li").hide()
		if(unit_search_text_box.length == 0)
			$('.unit-search').find('.form-group').append(search_input)
	else
		$("#search-form").removeClass('hide')
		$('#buildings-search-txt').val('')
		
		#hidding next submit button if no building selected
		next_btn_submit = $("#next_btn")
		if next_btn_submit.length > 0
			next_btn_submit.addClass('hidden')
		
		#append next link if no building selected
		next_btn = $("#next_to_review_btn")
		next_input = '<a id="next_to_review_btn" class="btn btn-primary add_new_building" href="javascript:;">Next</a>'
		if(next_btn.length == 0)
			$('.next_btn_container').append(next_input)
		
		$(".unit-search").addClass('hide')
		$("#new_unit_building").addClass('hide')
		$("#new_building").addClass('hide');
		$(".building_contribution").val(this.value)
		if(this.value=='building_review')
			href = '/reviews/new'
		else if(this.value == 'building_photos')
			if(user_id!='')
				href = '/uploads/new'
			else
				href = '/users/sign_in'

		$('#search_item_form').attr('action', href);

$(document).on 'click', '#elevator',(e) ->
	$('#building_elevator').toggleClass('hide')
	if($('#building_elevator').hasClass('hide'))
		$('#building_elevator').val('')
		$('#building_elevator').removeAttr('required')
	else
		$('#building_elevator').attr('required', 'required')

$(document).on 'click', '.reviewer_type',(e) ->
	id = $(this).children().attr('id')
	element = $("#review_stay_time")
	if(id == 'visitor')
		element.addClass('hide')
		element.next().hide()
		element.prev().hide()
		$("div.last_year_at_residence").addClass('hide')
		if(element.data('validate'))
			element.removeAttr('data-validate')
	else if(id == 'former_tenant') 
		$("div.last_year_at_residence").removeClass('hide')
		#$("#review_last_year_at_residence").prev().show()
		#$("#review_last_year_at_residence").next().show()
	else
		$("div.last_year_at_residence").addClass('hide')
		$("#review_stay_time").removeClass('hide')
		$("#review_stay_time").prev().show()
		$("#review_stay_time").next().show()

#preventing enter key to submit form 
$(document).on 'keypress', 'form',(e) ->
	if e.keyCode == 13 && e.target.tagName.toLowerCase() != 'textarea'
		return false
