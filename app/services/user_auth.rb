class UserAuth
	def initialize auth, current_user
		@auth 			  = auth
		@info 				= @auth.info
		@current_user = current_user
	end

	def from_omniauth
		if authorization.user.blank?
	    authorization.name      = @info.name
	    authorization.user_id   = auth_user.id
	    authorization.image_url = @info.image
	    authorization.save!
	  end
    return authorization
  end

  private
  
  def auth_user
		@current_user || existing_user || new_user
	end

	def existing_user
		User.find_by(email: @info.email)
	end

	def authorization
		@authorization ||= Authorization.where(:provider => provider, 
                         									 :uid     => uid).first_or_initialize
	end

	def provider
		@auth.provider
	end

	def uid
		@auth.uid
	end

  def new_user
    @new_user ||= User.create(email:    @info.email,
                							password: Devise.friendly_token[0,20],
                							name:     @info.name )
  end
end