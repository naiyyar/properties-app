$(document).on 'click', '#add_new_building',(e) ->
	e.preventDefault();
	$("#search-form").hide();
	$("#new_building").removeClass('hide');

$(document).on 'click', "input[name='contribute_to']",(e) ->
	
	if(this.value=='unit_review' || this.value=='unit_photos' || this.value=='unit_amenities' || this.value=='unit_price_history')
		$("#next_btn").hide()
		$("#new_unit_building").removeClass('hide')
		$("#unit_contribution").val(this.value)
		if(!$("#new_building").hasClass('hide'))
			$("#new_building").addClass('hide');
	else
		$("#search-form").show()
		$("#new_unit_building").addClass('hide')
		$("#new_building").addClass('hide');
		$(".building_contribution").val(this.value)
		if(this.value=='building_review')
			href = '/reviews/new'
		else if(this.value=='building_photos')
			href = '/uploads/new'
		else
			href = '#'

		$('#existing_buildings_form').attr('action', href);

$(document).on 'click', '#elevator',(e) ->
	$('#building_elevator').toggleClass('hide')

#On Unit Change
$(document).on 'change', '#unit_names_list_select',(e) ->
	unit_id = this.value
	$.ajax
		url: '/units/'+unit_id
		dataType: 'json'
		method: 'get'
		success: (data, textStatus, jqXHR) ->
			$("#unit_id").val(data.id)
			$("#unit_square_feet").val(parseInt(data.square_feet))
			$("#unit_number_of_bedrooms").val(data.number_of_bedrooms)
			$("#unit_number_of_bathrooms").val(data.number_of_bathrooms)