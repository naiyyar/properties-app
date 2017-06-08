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
		@contact = contact
		mail(
			to: 'transparentcityllc@gmail.com', 
			from: contact.email,
			subject: 'Feedback'
		)
	end

end
