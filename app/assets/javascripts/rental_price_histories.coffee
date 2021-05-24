# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

	$('.resident_to_year').on 'change',(e) ->
		
		start_year = $(".resident_from_year").val()
		end_year = $(".resident_to_year").val()
		
		if(start_year > end_year )
			$('.validation_error_message').removeClass('d-none')
			$("#resident_to_year").val('')
		else
			$('.validation_error_message').addClass('d-none');

	$('.resident_from_year').on 'change',(e) ->
		start_year = $(".resident_from_year").val()
		end_year = $(".resident_to_year").val()
		
		if(start_year > end_year && end_year != '')
			$('.start_validation_error_message').removeClass('d-none');
			$("#resident_from_year").val('')
		else
			$('.start_validation_error_message').addClass('d-none');

	# dismiss datepicker on mobile touch
	$("form#new_rental_price_history").on 'touchstart', (e) ->
		$('.dropdown-menu').css('display', 'none')

	$('.hide-datepicker').on 'click', (e) ->
		e.preventDefault()
		$('.dropdown-menu').css('display', 'none')

	# for mobile touch
	$('.hide-datepicker').on 'touchstart', (e) ->
		e.preventDefault()
		$('.dropdown-menu').css('display', 'none')
