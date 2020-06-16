class UserMailer < ApplicationMailer
	EMAIL_WITH_NAME = %(transparentcity <hello@transparentcity.co>)
	
	def password_reset_instructions
		email = 'no-reply@transparentcity.co'
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
			to: 'transparentcityllc@gmail.co', 
			from: contact.email,
			subject: 'Feedback'
		)
	end

	def review_marked_flag flag_review
		@user = flag_review.user
		@review = flag_review.review
		mail(
			to: 'transparentcityllc@gmail.co', 
			from: @user.email,
			subject: 'Review flagged as inappropriate'
		)
	end

	def contact_agent to_email, params
		@to_email      = to_email
		@from_email    = params[:email]
		@phone         = params[:phone]
		@neighborhoods = params[:neighborhoods]
		@bedrooms			 = params[:bedrooms]
		@budget        = params[:budget]
		@message			 = params[:message]
		subject = "[Inquiry From Transparentcity User] regarding assistance on rental apartment search from #{@from_email}"
		mail(
			from: EMAIL_WITH_NAME,
			reply_to: @from_email,
			to: @to_email,
			# cc: "#{@from_email}, hello@transparentcity.co",  
			subject: subject
		)
	end

	def contact_agent_sender_copy agent, sender_email
		mail(
			from: EMAIL_WITH_NAME,
			reply_to: sender_email,
			to: sender_email,
			subject: "Your message to #{agent.full_name} has been sent."
		)
	end


	######## EMAIL Structure ########
	# from:		transparentcity <hello@transparentcity.co>
	# reply-to:	userwhosentmessage@email.com
	# to:		propertymanageremailspecifiedateditbuilding@email.com
	# date:		system generated at time of message sent
	# subject:	[Rental Inquiry From TransparentCity User] Regarding availability at Building Name from Email 
	# mailed-by:	hello.transparentcity.co
	# signed-by:	transparentcity.co

	def send_enquiry_to_building contact
		@contact = contact
		@contact_email = @contact.email
		@building = contact.building
		@building_name = @building.building_name_or_address
		subject = "[Rental Inquiry From TransparentCity User] Regarding availability at #{@building_name} from #{@contact_email}"
		
		mail(
			to: @building.email,
			bcc: 'hello@transparentcity.co',
			reply_to: @contact_email,
			from: EMAIL_WITH_NAME,
			subject: subject
		)
	end


	# from:		transparentcity <hello@transparentcity.co>
	# reply-to:	senderemail@email.com
	# to:		senderemail@email.com
	# date:		system generated at time of message sent
	# subject:	Your message about {Building Name} has been sent
	# mailed-by:	hello.transparentcity.co
	# signed-by:	transparentcity.co
	def enquiry_sent_mail_to_sender contact
		@contact 				= contact
		@contact_email 	= @contact.email
		@building 			= contact.building
		@building_name 	= @building.building_name_or_address
		subject 				= "Your message about #{@building_name} has been sent."
		email_with_name = %(transparentcity <hello@transparentcity.co>)
		mail(
			to: @contact_email,
			reply_to: @contact_email,
			from: EMAIL_WITH_NAME,
			subject: subject
		)
	end

end
