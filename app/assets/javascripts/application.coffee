#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require contribute
#= require_tree .

jQuery ->
	$('.datepicker').datepicker({
		format: 'dd-mm-yyyy'
	});
	$('[data-toggle="popover"]').popover({ trigger: "hover" })

	$('input, textarea').placeholder()

	$(document).on "page:change", ->
  		$(".dropzone").dropzone()
	    	paramName: "upload[image][]",
	    	uploadMultiple: true,
	    	parallelUploads: 100,
	    	maxFiles: 100