class UserMailer < ApplicationMailer
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

	def contact_agent agent, params
		@to_email      = agent.email
		@from_email    = params[:email]
		@phone         = params[:phone]
		@neighborhoods = params[:neighborhoods]
		@bedrooms			 = params[:bedrooms]
		@budget        = params[:budget]
		@message			 = params[:message]
		@agent_name    = agent.full_name
		subject = "[Inquiry From Transparentcity User] regarding assistance on rental apartment search from #{@from_email}"
		mail(
			from: DEFAULT_EMAIL,
			reply_to: @from_email,
			to: @to_email,
			bcc: 'hello@transparentcity.co',  
			subject: subject
		)
	end

	def contact_agent_sender_copy agent, params
		@to_email 	   = agent.email
		sender_email   = params[:email]
		@phone         = params[:phone]
		@neighborhoods = params[:neighborhoods]
		@bedrooms			 = params[:bedrooms]
		@budget        = params[:budget]
		@message			 = params[:message]
		@agent_name    = agent.full_name
		mail(
			from: DEFAULT_EMAIL,
			reply_to: sender_email,
			to: sender_email,
			subject: "Your message to #{@agent_name} has been sent."
		)
	end

	def contact_frbo listing, params
		@listing = listing
		@to_email = listing.email
		@from_email = params[:email]
		@phone = params[:phone]
		@message = params[:message]
		@owner_name  = listing.owner_full_name
		@address_with_unit = @listing.address_with_unit
		mail(
			from: DEFAULT_EMAIL,
			reply_to: @from_email,
			to: @to_email,
			bcc: 'hello@transparentcity.co',
			subject: frbo_subject
		)
	end

	def send_frbo_email_to_renter listing, params
		@listing = listing
		@to_email = listing.email
		@from_email = params[:email]
		@phone = params[:phone]
		@message = params[:message]
		@address_with_unit = @listing.address_with_unit
		mail(
			from: DEFAULT_EMAIL,
			reply_to: @from_email,
			to: @from_email,
			subject: "Your Inquiry Regarding #{@address_with_unit} Has Been Sent"
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
			from: DEFAULT_EMAIL,
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
		mail(
			to: @contact_email,
			reply_to: @contact_email,
			from: DEFAULT_EMAIL,
			subject: subject
		)
	end

	private
	
	def frbo_subject
		"[Inquiry From Transparentcity User] Availability At #{@address_with_unit} from #{@from_email}"
	end

end
