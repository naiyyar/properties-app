module DeviseHelper
	def devise_error_messages!
		if resource.errors.full_messages.blank?
			#resource.errors.full_messages << 'Incorrect user name or password.'
     		flash[:error] = 'Incorrect user name or password.'
     	end
  	end
end