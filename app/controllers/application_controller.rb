class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Pagy::Backend
  
  # modules
  include BuildingsCountConcern
  include CreateReviewConcern
  include SetTimezoneConcern
  include WickedPdfConcern
  
  def store_location
    # store last url as long as it isn't a /users path
    return unless request.format.html?

    session[:return_to] = request.fullpath unless request.fullpath =~ /\/users/
  end

  def model_class
    @model_class ||= controller_name.singularize.camelize.constantize
  end

  helper_method :model_class

  private

  rescue_from CanCan::AccessDenied do |exception|
    unless exception.message == 'You are not authorized to access this page.'
      redirect_to redirect_back_or_default(root_url), notice: exception.message
    else
      redirect_to '/404'
    end
  end

  def redirect_back_or_default(default)
    session[:return_to] || default
  end

  before_action :update_last_sign_in_at

  protected

  def update_last_sign_in_at
    if user_signed_in? && !session[:logged_signin]
      sign_in(current_user, :force => true)
      session[:logged_signin] = true
    end
  end

end
