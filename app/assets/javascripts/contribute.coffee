$(document).on 'click', '#add_new_building',(e) ->
	e.preventDefault();
	$("#search-form").hide();
	$("#new_building").removeClass('hide');

$(document).on 'click', '#submit_review',(e) ->
	if($("input[name='score']").val()== '')
		e.preventDefault();
		$(".rating-not-selected").removeClass('hide')
		return false
	else if(!$('.reviewer_type').hasClass('active'))
		$(".status-not-selected").removeClass('hide')
		return false
	else
		$(".rating-not-selected").addClass('hide')
		$(".status-not-selected").addClass('hide')
		return true


$(document).on 'click', '#add_new_unit',(e) ->
	e.preventDefault();
	$("#unit_id").val('');
	$("#unit_name").val('');
	$("#unit_square_feet").val('');
	$("#unit_number_of_bedrooms").val('');
	$("#unit_number_of_bathrooms").val('');
	$("#new_unit_building").removeClass('hide')
	$("#unit-search").addClass('hide');


$(document).on 'click', "input[name='contribute_to']",(e) ->
	if(this.value=='unit_review' || this.value=='unit_photos' || this.value=='unit_amenities' || this.value=='unit_price_history')
		$("#next_btn").hide()
		$("#unit_contribution").val(this.value)
		if(!$("#new_building").hasClass('hide'))
			$("#new_building").addClass('hide');
	else
		$("#search-form, #next_btn").show()
		$("#new_unit_building").addClass('hide')
		$("#new_building").addClass('hide');
		$(".building_contribution").val(this.value)
		if(this.value=='building_review')
			href = '/reviews/new'
		else if(this.value=='building_photos')
			href = '/uploads/new'

		$('#search_item_form').attr('action', href);

$(document).on 'click', '#elevator',(e) ->
	$('#building_elevator').toggleClass('hide')
	if($('#building_elevator').hasClass('hide'))
		$('#building_elevator').val('')

$(document).on 'click', '.reviewer_type',(e) ->
	id= $(this).children().attr('id')
	if(id == 'visitor')
		$("#review_stay_time").addClass('hide')
		$("#review_stay_time").next().hide()
	else
		$("#review_stay_time").removeClass('hide')
