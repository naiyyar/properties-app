jQuery ->
	$(document).on 'click', "form", (e) ->
		submit = true
		window.data = $(this)
		elems = $(this).find('.validate')
		#elems = $('input').filter('.validate')
		len = elems.length - 1
		for i in [0..len] by 1
		  if $(elems[i]).val() == '' || $(elems[i]).val() == '0.0'
		  	$(elems[i]).parent().addClass('has-error')
		  	submit = false
		  else
		  	$(elems[i]).parent().removeClass('has-error')

		submit
		 