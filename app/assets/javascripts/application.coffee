#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require login
#= require contribute
#= require_tree .

jQuery ->
	$('.datepicker').datepicker({
		format: 'dd-mm-yyyy'
	});
	$('[data-toggle="popover"]').popover({ trigger: "hover" })

	$('input, textarea').placeholder()