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

	def send_feedback contact
		mail(
			to: 'naiyyarabbas@yahoo.com', 
			from: contact.email,
			subject: 'Feedback',
			body: contact.comment
		)
	end

end
