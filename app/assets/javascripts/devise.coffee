#submitting sign in / Sign up form

$(document).bind 'ajax:success', "form#sign_in_user, form#sign_up_user", (e, data, status, xhr) ->
	if(data.success)
		$('#error_explanation b').html('')
		$('#user_password').next().html('')
		window.location.reload()
	else
		$('#user_email_signup, #signup_user_password').next().html('')
		if data.data != undefined
			emailErrors(data.data.message)
			passwordErrors(data.data.message)
		
		recapcha_help_block = $('.apt-captcha').children('.help-block')
		
		if(data.data != undefined && data.data.message.recaptcha)
			recapcha_help_block.addClass('has-error').html(data.data.message.recaptcha[0])
			if $('#user_email_signup').val() == ''
				message = { email: ["can't be blank"] }
				emailErrors(message)

			if $('#signup_user_password').val() == ''
				message = {password: ["Password can't be blank"]}
				passwordErrors(message)
		
		else
			recapcha_help_block.removeClass('has-error')


emailErrors = (message) ->
	if(message.email)
		$('#user_email_signup').parent().addClass('has-error')
		if(message.email[0] == 'is invalid')
			$('#user_email_signup').next().append('Please enter a valid email address')
		else if(message.email[0] == "can't be blank")
			$('#user_email_signup').next().append("can't be blank")
		else if(message.email[0] == 'has already been taken')
			$('#user_email_signup').next().append('Email has already been taken')
		else
			$('#user_email_signup').parent().removeClass('has-error')
			$('#user_email_signup').next().html('')
	else
		$('#user_email_signup').parent().removeClass('has-error')
		$('#user_email_signup').next().html('')

passwordErrors = (message) ->
	password_field = $('#signup_user_password')
	if(message.password)
		$(password_field).parent().addClass('has-error')
		$(password_field).next().html(message.password[0])
	else
		$(password_field).parent().removeClass('has-error')
		$(password_field).next().html('')


$(document).bind 'ajax:error', 'form#sign_in_user, form#sign_up_user', (e, data, status, xhr) ->
	password_field = $('#user_password')
	email_field = $('#user_email')
	$('#user_email, #user_password').next().html('')

	if(email_field.val() == '')
		email_field.next().append("can't be blank")
	else
		$('#user_email').next().html('')

	#if password is blank
	if(password_field.val() == '')
		password_field.next().append("can't be blank")
	else
		password_field.next().append('Login failed. Please try again')

	$('#error_explanation b').html('')
	$('#error_explanation b').hide().show().append(data.responseText)
	$('#user_email, #user_password').parent().addClass('has-error')