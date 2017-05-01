(function() {
  $(document).bind('ajax:success', "form#sign_in_user, form#sign_up_user", function(e, data, status, xhr) {
    var password_field;
    window.data = data;
    if (data.success) {
      $('#error_explanation b').html('');
      $('#user_password').next().html('');
      return window.location.reload();
    } else {
      $('#user_email_signup, #signup_user_password').next().html('');
      password_field = $('#signup_user_password');
      if (data.data.message.email) {
        $('#user_email_signup').parent().addClass('has-error');
        if (data.data.message.email[0] === 'is invalid') {
          $('#user_email_signup').next().append('Please enter a valid email address');
        } else if (data.data.message.email[0] === "can't be blank") {
          $('#user_email_signup').next().append("can't be blank");
        } else if (data.data.message.email[0] === 'has already been taken') {
          $('#user_email_signup').next().append('Email has already been taken');
        } else {
          $('#user_email_signup').parent().removeClass('has-error');
          $('#user_email_signup').next().html('');
        }
      } else {
        $('#user_email_signup').parent().removeClass('has-error');
        $('#user_email_signup').next().html('');
      }
      if (data.data.message.password) {
        $(password_field).parent().addClass('has-error');
        return $(password_field).next().append(data.data.message.password[0]);
      } else {
        $(password_field).parent().removeClass('has-error');
        return $(password_field).next().html('');
      }
    }
  });

  $(document).bind('ajax:error', 'form#sign_in_user, form#sign_up_user', function(e, data, status, xhr) {
    var email_field, password_field;
    password_field = $('#user_password');
    email_field = $('#user_email');
    $('#user_email, #user_password').next().html('');
    if (email_field.val() === '') {
      email_field.next().append("can't be blank");
    } else {
      $('#user_email').next().html('');
    }
    if (password_field.val() === '') {
      password_field.next().append("can't be blank");
    } else {
      password_field.next().append('Login failed. Please try again');
    }
    $('#error_explanation b').html('');
    $('#error_explanation b').hide().show().append(data.responseText);
    return $('#user_email, #user_password').parent().addClass('has-error');
  });

}).call(this);
