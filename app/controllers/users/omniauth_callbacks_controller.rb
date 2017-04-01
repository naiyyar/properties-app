class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  def all
    user = User.from_omniauth(request.env['omniauth.auth'], current_user)
    if user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => User::SOCIALS[params[:action].to_sym]
      session[:provider] = User::SOCIALS[params[:action].to_sym]
      sign_in_and_redirect(user)
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to :back
    end
  end

  # def facebook
  #   # You need to implement the method below in your model (e.g. app/models/user.rb)
  #   @user = User.from_omniauth(request.env['omniauth.auth'])
  #   if @user.persisted?
  #     sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
  #     set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
  #   else
  #     session["devise.facebook_data"] = request.env["omniauth.auth"]
  #     redirect_to :back #, new_user_registration_url
  #   end
  # end

  # def google_oauth2
  #   @user = User.from_omniauth(request.env["omniauth.auth"])

  #   if @user.persisted?
  #     flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
  #     sign_in_and_redirect @user, :event => :authentication
  #   else
  #     session["devise.google_data"] = request.env["omniauth.auth"].except(:extra) #Removing extra as it can overflow some session stores
  #     redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
  #   end
  # end

  def failure
    super
  end

  User::SOCIALS.each do |k, _|
    alias_method k, :all
  end

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
