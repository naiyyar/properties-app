$(document).on 'click', '#add_new_building',(e) ->
	e.preventDefault();
	$("#search-form").hide();
	$("#new_building").removeClass('hide');

$(document).on 'click', "input[name='contribute_to']",(e) ->
	
	
	if(this.value=='unit_review' || this.value=='unit_photos' || this.value=='unit_amenities' || this.value=='unit_price_history')
		$("#search-form").hide()
		$("#new_unit_building").removeClass('hide')
		$("#unit_contribution").val(this.value)
		if(!$("#new_building").hasClass('hide'))
			$("#new_building").addClass('hide');
	else
		$("#search-form").show()
		$("#new_unit_building").addClass('hide')
		$("#contribution").val(this.value)