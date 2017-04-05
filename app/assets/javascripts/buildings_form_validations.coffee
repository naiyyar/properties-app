jQuery ->
	$(document).on 'click', "#new_building_submit", (e) ->
		submit = true
		elems = $('#new_building input[type=text]').filter('.validate')
		len = elems.length - 1
		for i in [0..len] by 1
		  if $(elems[i]).val() == ''
		  	$(elems[i]).parent().addClass('has-error')
		  	submit = false
		  else
		  	$(elems[i]).parent().removeClass('has-error')

		submit
		 