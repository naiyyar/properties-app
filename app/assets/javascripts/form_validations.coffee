jQuery ->
	$(document).on 'click', "form", (e) ->
		submit = true
		elems = $(this).find('.validate')
		len = elems.length - 1
		for i in [0..len] by 1
		  if $(elems[i]).val() == '' || $(elems[i]).val() == '0.0'
		  	$(elems[i]).parent().addClass('has-error')
		  	submit = false
		  else
		  	$(elems[i]).parent().removeClass('has-error')

		submit
		 