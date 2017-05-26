# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->

	$('#rental_price_history_residence_end_date').on 'changeDate',(e) ->
		start_date = $("#rental_price_history_residence_start_date").val()
		end_date = $("#rental_price_history_residence_end_date").val()
		if((Date.parse(start_date) > Date.parse(end_date)))
			$('.validation_error_message').removeClass('hidden');
			$("#rental_price_history_residence_end_date").val('')
		else
			$('.validation_error_message').addClass('hidden');

	$('#rental_price_history_residence_start_date').on 'changeDate',(e) ->
		start_date = $("#rental_price_history_residence_start_date").val()
		end_date = $("#rental_price_history_residence_end_date").val()
		if((Date.parse(start_date) > Date.parse(end_date)))
			$('.start_validation_error_message').removeClass('hidden');
			$("#rental_price_history_residence_start_date").val('')
		else
			$('.start_validation_error_message').addClass('hidden');

	#dismiss datepicker on mobile touch
	$("form#new_rental_price_history").on 'touchend', (e) ->
		$('.dropdown-menu').css('display', 'none')

	$("#rental_price_history_residence_start_date").on 'touchstart', (e) ->
		$('.dropdown-menu').css('display', 'block')

	$("#rental_price_history_residence_end_date").on 'touchstart', (e) ->
		$('.dropdown-menu').css('display', 'block')

	$('.hide-datepicker').on 'click', (e) ->
		$('.dropdown-menu').css('display', 'none')
