var ready = function () {
	//var shiftHold = false;
	var lastChecked = null;
	var dtr, listing_box;

	$(document).on('click', '.listing-box', function(e) {
		aptListing.selectRows(e, $(this));
	});

	$(document).on('click', '.check_all_listing', function(e){
		dtr = $('.dataTable > tbody tr');
		listing_box = dtr.find('.listing-box');
		aptListing.checkAll($(this), dtr, listing_box);
	});

	//==============================
	//rows selection using shift key
	//==============================
	// $(document).on('keydown', function(e){
	// 	if(e.keyCode == 16){ shiftHold = true }
	// });

	aptListing = {
		//
		// selecting rows one by one Or multiple using shift press 
		//
		selectRows: function(e, elem) {
	    var elems, end, from, listing_id, selected_row, start, to;
	    selected_row = elem.parent().parent();
	    listing_id = $(selected_row).data('id');
	    if (elem.is(':checked')) {
	      selected_row.addClass('selected');
	      aptListing.appendIdsContainerInputToForms(listing_id);
	      aptListing.setListingActionButtonsStatus();
	      if(!lastChecked){
	        lastChecked = elem[0];
	        return;
	      }
	      
	      if(e.shiftKey){
	        from = $('.listing-box').index(elem[0]);
	        to = $('.listing-box').index(lastChecked);
	        start = Math.min(from, to);
	        end = Math.max(from, to) + 1;
	        elems = $('.listing-box').slice(start, end).attr('checked', lastChecked.checked).trigger('change');
	        $.each(elems, function(i, j) {
	          var p_tr;
	          if (!$(j).is(':checked')) {
	            $(j).prop('checked', true);
	          } else {

	          }
	          p_tr = $(j).parent().parent();
	          if (!p_tr.hasClass('selected')) {
	            p_tr.addClass('selected');
	            aptListing.appendIdsContainerInputToForms(p_tr.data('id'));
	          } else {

	          }
	        });
	      }
	      return lastChecked = elem[0];
	    } else {
	      selected_row.removeClass('selected');
	      aptListing.removeIdsContainerInputToForms(listing_id);
	      aptListing.setListingActionButtonsStatus();
	    }
		},

		appendIdsContainerInputToForms: function(listing_id){
			var inputToAppend = '<input type="hidden" name="selected_ids[]" id="selected_ids_on" class="selected_ids selected_ids_'+listing_id+'" value="'+listing_id+'">';
			$('#active_on_action_form').append(inputToAppend);
			$('#active_off_action_form').append(inputToAppend);
			$('#delete_action_form').append(inputToAppend);
		},

		removeIdsContainerInputToForms: function(listing_id){
			$('.selected_ids_'+listing_id).remove();
		},

		setListingActionButtonsStatus: function(){
			var actions = $('.listing-actions');
			if($('.dataTable').find('tr.selected').length > 0){
				actions.show(300);
				aptListing.changeCheckAllBoxStatus(true);
			}else{
				actions.hide(300);
				aptListing.changeCheckAllBoxStatus(false);
			}
		},
		//changing check all checkbox status to true when there is at least one checkbox is checked.
		//calling from inside setListingActionButtonsStatus method
		changeCheckAllBoxStatus: function(status){
			$('#check_all_listing').prop('checked', status)
		},

		checkAll: function(elem, dtr, listing_box ){
			if(elem.is(':checked')){
				dtr.addClass('selected');
				listing_box.prop('checked', true);
				$.each(dtr, function(i, j){
					id = $(j).data('id');
					if(id != undefined){
						aptListing.appendIdsContainerInputToForms(id);
					}
				});
			}else{
				dtr.removeClass('selected');
				listing_box.prop('checked', false);
				$.each(dtr, function(i, j){
					aptListing.removeIdsContainerInputToForms($(j).data('id'));
				});
			}
			aptListing.setListingActionButtonsStatus()
		}

	} //end listing object

};

$(document).ready(ready);
$(document).on("page:load", ready);

