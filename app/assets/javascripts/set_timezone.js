document.addEventListener('DOMContentLoaded', function() {
	// setting timezone
	$('.user_time_zone').set_timezone(); 
	const timezone = $('.user_time_zone').val(); 
	// setting in cookies to access using helper method on application controller
	function setCookie(name, value) {
	  var expires = new Date()
	  expires.setTime(expires.getTime() + (24 * 60 * 60 * 1000))
	  document.cookie = name + '=' + value + ';expires=' + expires.toUTCString()
	}
	setCookie("timezone", timezone);
}, false);