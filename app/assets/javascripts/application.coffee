#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require contribute
#= require form_validations
#= require devise
#= require_tree .

jQuery ->
	#$('[data-toggle="popover"]').popover({ trigger: "click" })

	#removing hash after facebook login
	if(window.location.hash && window.location.hash == '#_=_')
    window.location.hash = ''

	$('input, textarea').placeholder()

	$(document).on 'click', '.left-side-zindex', (e) ->
		parentElem = $(this).parents().find('#leftSide')
		if(parentElem.hasClass('expanded'))
			parentElem.css('z-index', 999)

	window.setTimeout (->
       	$('.alert').slideUp 300, ->
         	$(this).remove()
     	), 1000

ready = ->
	$('[data-toggle="tooltip"]').tooltip({ trigger: 'click' })

	$('.datepicker').datepicker
		format: 'mm-dd-yyyy'

	$('.datepicker').on 'changeDate',(e) ->
		$(this).datepicker('hide');

$(document).ready(ready)
$(document).on('page:load', ready)