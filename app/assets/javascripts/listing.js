var ready = function () {
	$('#sortable').checkboxes('range', true);

	$(document).on('click', '.check_all_listing', function(e){
		if($(this).is(':checked')){
			$('#sortable').checkboxes('check');
		}else{
			$('#sortable').checkboxes('uncheck');
		}
	});

	aptListing = {
		appendIdsContainerInputToForms: function(listing_id){
			var inputToAppend = '<input type="hidden" name="selected_ids[]" id="selected_ids_on" class="selected_ids selected_ids_'+listing_id+'" value="'+listing_id+'">';
			$('#active_on_action_form').append(inputToAppend);
			$('#active_off_action_form').append(inputToAppend);
			$('#delete_action_form').append(inputToAppend);
		},

		removeIdsContainerInputToForms: function(listing_id){
			$('.selected_ids_'+listing_id).remove();
		},

	} // end listing object

};

$(document).ready(ready);
$(document).on("page:load", ready);

