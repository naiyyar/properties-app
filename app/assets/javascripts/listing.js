var ready = function () {
	$('#sortable').checkboxes('range', true);

	$(document).on('click', '.check_all_listing', function(e){
		if($(this).is(':checked')){
			$('#sortable').checkboxes('check');
		}else{
			$('#sortable').checkboxes('uncheck');
		}
	});

	listing_action_form_ids = [
								'#active_on_action_form', 
								'#active_off_action_form', 
								'#delete_action_form',
								'#transfer_all_action_form'
			]

	aptListing = {
		appendIdsContainerInputToForms: function(listing_id){
			var inputToAppend = '<input type="hidden"' +
																	'name="selected_ids[]"' +
																	'id="selected_ids_on_'+listing_id+'"' +
																	'class="selected_ids selected_ids_'+listing_id+'"' +
																	'value="'+listing_id+'">';
			
			for(i = 0; i < listing_action_form_ids.length; i++){
				$(listing_action_form_ids[i]).append(inputToAppend);
			}
		},

		removeIdsContainerInputToForms: function(listing_id){
			$('.selected_ids_'+listing_id).remove();
		},

	} // end listing object

};

$(document).ready(ready);
$(document).on("page:load", ready);

