#= require jquery
#= require jquery_ujs
#= require contribute
#= require form_validations
#= require devise
#= require social-share-button
#= require filters
#= require light_slider
#= require_tree .

jQuery ->
	#$('[data-toggle="popover"]').popover({ trigger: "click" })

	#removing hash after facebook login
	if(window.location.hash && window.location.hash == '#_=_')
    window.location.hash = ''

	$('input, textarea').placeholder()

	$('#sortable').DataTable({
		paging: false,
		scrollY: 400,
		"order": []
	})

	#using to open property show page on infowindow click
	$(document).on 'click', '.infoW-property-info', (e) ->
		url = $(this).data('href')
		#window.open(url)
		window.location.href = url
	
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
		format: 'yyyy-mm-dd'

	$('.datepicker').on 'changeDate',(e) ->
		$(this).datepicker('hide')

$(document).ready(ready)
$(document).on('page:load', ready)