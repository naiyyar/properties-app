jQuery ->
	#from uploads/index page
	$(document).on 'click', '.delete_image',(e) ->
		parent = $(this).parent();
		if parent.hasClass('actions-links')
			$(this).parent().parent().hide(500);
		else
			$(this).parent().hide(500);
	
	$('[data-toggle="tooltip"]').tooltip();

	#removing hash after facebook login
	if(window.location.hash && window.location.hash == '#_=_')
    window.location.hash = ''

	$('input, textarea').placeholder()

	#using to open property show page on infowindow click
	$(document).on 'click', '.infoW-property-info', (e) ->
		url = $(this).data('href')
		window.location.href = url
	
	$(document).on 'click', '.left-side-zindex', (e) ->
		parentElem = $(this).parents().find('#leftSide')
		if(parentElem.hasClass('expanded'))
			parentElem.css('z-index', 999)

	$(document).on 'click', '.cancel', (e) ->
		e.preventDefault
		window.location.href = $(this).attr('href')

	window.setTimeout (->
   	$('.alert').slideUp 300, ->
     	$(this).remove()
 	), 1000

ready = ->
	$('[data-toggle="tooltip"]').tooltip({ trigger: 'click' })
	#
	$('#wrapper').removeAttr('style');

	#
	data_sortable = $('#sortable').DataTable({
	  paging: false,
	  scrollY: false,
	  scrollX: true,
	  "order": [],
	  "columnDefs": [
	    { "orderable": false, "targets": 'no-sort' }
	  ]
	});

	$('.datepicker').datepicker
		format: 'yyyy-mm-dd'

	$('.datepicker').on 'changeDate',(e) ->
		$(this).datepicker('hide')

$(document).ready(ready)
$(document).on('page:load', ready)