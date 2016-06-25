#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require turbolinks
#= require login
#= require contribute
#= require_tree .

jQuery ->
	$('.datepicker').datepicker({
		format: 'dd-mm-yyyy'
	});