$(document).ready(function(){
	FEATURED_LISTING = {
		showContactOwnerFormModal: function(prop_id){
		  $.ajax({
		    url: '/featured_listings/'+prop_id+'/contact_owner',
		    type: 'get',
		    dataType: 'script',
		    success: function(response){
		    	// console.log('xxxx')
		    }
		  });
		}
	}
});