class Users::SessionsController < Devise::SessionsController
  # before_filter :configure_sign_in_params, only: [:create]
   respond_to :html, :json
  # GET /resource/sign_in
  def new
    @search_bar_hidden = :hidden
    super
  end

  # POST /resource/sign_in
  def create
    time_zone = params[:user][:time_zone]
    session['user_auth'] = params[:user]
    resource = warden.authenticate!(:scope => resource_name, :recall => "#{controller_path}#failure")
    sign_in(resource_name, resource)
    message = I18n.t 'devise.sessions.signed_in'
    resource.set_timezone(time_zone) if time_zone != resource.time_zone
    yield resource if block_given?

    if request.xhr?
      return render :json => {:success => true, :login => true, :data =>  {:message => message}}
    else
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end

  def failure
    user = User.find_by(email: session['user_auth'][:email])
    message = I18n.t 'devise.failure.invalid', authentication_keys: 'email'

    respond_to do |format|
      format.json {
        render :json => { :success => false, :errors => ["Login failed."] }
      }
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  #protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end
end
