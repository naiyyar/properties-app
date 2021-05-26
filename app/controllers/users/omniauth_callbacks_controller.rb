class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  def all
    auth = UserAuthService.new(request.env['omniauth.auth'], current_user)
    user = auth.from_omniauth.user
    user.set_timezone(browser_time_zone.name)
    if user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => User::SOCIALS[params[:action].to_sym]
      session[:provider] = User::SOCIALS[params[:action].to_sym]
      sign_in_and_redirect(user)
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to request.referer
    end
  end

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
