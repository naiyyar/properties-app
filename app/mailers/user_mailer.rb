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
		@contact_email = @contact.email
		@building = contact.building
		@building_name = @building.building_name_or_address
		subject = "[Rental Inquiry From TransparentCity User] Regarding availability at #{@building_name} from #{@contact_email}"
		mail(
			to: @building.email,
			cc: ['hello@transparentcity.com', 'naiyyarabbas512013@gmail.com'],
			from: @contact_email,
			subject: subject
		)
	end

	def enquiry_sent_mail_to_sender contact
		@contact = contact
		@contact_email = @contact.email
		@building = contact.building
		@building_name = @building.building_name_or_address
		subject = "Your message about #{@building_name} has been sent."
		mail(
			to: @contact_email,
			cc: ['hello@transparentcity.com', 'naiyyarabbas512013@gmail.com'], 
			from: 'no-reply@transparentcity.com',
			subject: subject
		)
	end

end
