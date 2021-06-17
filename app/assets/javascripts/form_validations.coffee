jQuery ->
	$(document).on 'click', "form", (e) ->
		submit = true
		error_class = 'is-invalid'
		elems = $(this).find('.validate')
		len = elems.length - 1
		for i in [0..len] by 1
		  if $(elems[i]).val() == '' || $(elems[i]).val() == '0.0'
		  	$(elems[i]).addClass(error_class)
		  	submit = false
		  else
		  	$(elems[i]).removeClass(error_class)

		submit
		 