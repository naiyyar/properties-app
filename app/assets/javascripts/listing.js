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
		//
		// selecting rows one by one Or multiple using shift press 
		//
		// selectRows: function(e, elem) {
	 //    var listing_id, selected_row;
	 //    selected_row = elem.parent().parent();
	 //    listing_id = $(selected_row).data('id');
	 //    if (elem.is(':checked')) {
	 //      //selected_row.addClass('selected');
	 //      aptListing.appendIdsContainerInputToForms(listing_id);
	 //      aptListing.setListingActionButtonsStatus();
	 //      //aptListing.shiftSelectRows(e, elem[0]);
	 //    } else {
	 //      //selected_row.removeClass('selected');
	 //      aptListing.removeIdsContainerInputToForms(listing_id);
	 //      aptListing.setListingActionButtonsStatus();
	 //    }
		// },

		// shiftSelectRows: function(e, elem){
		// 	var elems, end, from, start, to;
		// 	if(!lastChecked){
  //       lastChecked = elem;
  //       return;
  //     }
      
  //     if(e.shiftKey){
  //     	checkboxes = $('.listing-box');
  //       to = checkboxes.index(elem);
  //       from = checkboxes.index(lastChecked);
  //       start = Math.min(from, to);
  //       end = Math.max(from, to) + 1;
  //       elems = checkboxes.slice(start, end).attr('checked', lastChecked.checked).trigger('change');
  //       $.each(elems, function(i, j) {
  //         var p_tr = $(j).parent().parent();
  //         if (!p_tr.hasClass('selected')) {
  //           p_tr.addClass('selected');
  //           aptListing.appendIdsContainerInputToForms(p_tr.data('id'));
  //         }
  //       });
  //     }
  //     lastChecked = elem;
		// },

		appendIdsContainerInputToForms: function(listing_id){
			var inputToAppend = '<input type="hidden" name="selected_ids[]" id="selected_ids_on" class="selected_ids selected_ids_'+listing_id+'" value="'+listing_id+'">';
			$('#active_on_action_form').append(inputToAppend);
			$('#active_off_action_form').append(inputToAppend);
			$('#delete_action_form').append(inputToAppend);
		},

		removeIdsContainerInputToForms: function(listing_id){
			$('.selected_ids_'+listing_id).remove();
		},

	} //end listing object

};

$(document).ready(ready);
$(document).on("page:load", ready);

