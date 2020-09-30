var ready = function () {
	var mask_options = {
	  onKeyPress: function(cep, e, field, options) {
	    if(cep == '(') {
	      field.val('');
	    }
	  }
	};
	$('.phone_number').mask("(000) 000-0000", mask_options);
	$('#card-number').mask("0000 0000 0000 0000 000", mask_options);
	$('#card-cvc').mask("0000", mask_options);
}

$(document).ready(ready);
$(document).on("page:load", ready);