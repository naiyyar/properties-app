class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, except: :load_infobox
  # Filters
  before_action :allow_iframe_requests
  after_action  :store_location, unless: :skip_store_location
  
  # layouts
  layout :set_layout

  #helpers
  helper_method :gmap_url_helper
  
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

  private

  def set_layout
    if action_name == 'index' && controller_name == 'home'
      'home'
    elsif search_layout?
      'search'
    elsif action_name == 'show' && controller_name == 'buildings'
      'buildings_show'
    else
      'application'
    end
  end

  def search_layout?
    (action_name == 'search' && controller_name == 'home') || action_name == 'saved_buildings'
  end

  def controllers
    ['users/sessions', 'users/registrations', 'buildings', 'reviews']
  end

  def actions
    %w(new contribute index)
  end

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

  def allow_iframe_requests
    response.headers.delete('X-Frame-Options')
  end

  before_action :update_last_sign_in_at

  def gmap_url_helper
    @gmap_url_helper ||= "https://maps.google.com/maps/api/js?v=3.42&key=#{ENV['GEOCODER_API_KEY']}&libraries=places"
  end

  protected

  def update_last_sign_in_at
    if user_signed_in? && !session[:logged_signin]
      sign_in(current_user, :force => true)
      session[:logged_signin] = true
    end
  end

  def skip_store_location
    request.format.json? || request.format.js?
  end

end
