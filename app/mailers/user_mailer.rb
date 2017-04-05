class UserMailer < ApplicationMailer

	def password_reset_instructions
  		email = 'no-reply@transparentcity.com'
  		to = self.email
  		mail(
  			to: to, 
  			from: email,
  			subject: 'Password Reset Instructions'
  		)
  	end

end
