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

	def review_marked_flag flag_review
		@user = flag_review.user
		@review = flag_review.review
		mail(
			to: 'transparentcityllc@gmail.com', 
			from: @user.email,
			subject: 'Review flagged as inappropriate'
		)
	end

	def send_enquiry_to_building contact
		@contact = contact
		@building = contact.building
		mail(
			to: @building.email,
			cc: 'transparentcityllc@gmail.com', 
			from: contact.email,
			subject: 'Interested in availabilities'
		)
	end

end
