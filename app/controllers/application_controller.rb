class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, except: :load_infobox

  before_action :allow_iframe_requests
  after_action  :store_location, unless: :skip_store_location
  before_action :popular_neighborhoods
  before_action :set_timezone, if: :user_signed_in?

  helper_method :browser_time_zone, :uptown_count,
                :brooklyn_count, :queens_count, :bronx_count

  layout :set_layout

  def set_timezone
    Time.zone = current_user.time_zone
  end

  def browser_time_zone
    browser_tz = ActiveSupport::TimeZone.find_tzinfo(cookies[:timezone])
    browser_tz || Time.zone
  rescue TZInfo::UnknownTimezone, TZInfo::InvalidTimezoneIdentifier
    Time.zone
  end
  
  def store_location
    # store last url as long as it isn't a /users path
    return unless request.format.html?

    session[:return_to] = request.fullpath unless request.fullpath =~ /\/users/
  end

  def popular_neighborhoods
    @pop_nb_hash = {}
    pop_neighborhoods.each{ |nb| @pop_nb_hash[nb.name] = nb.buildings_count }
  end

  def uptown_count
    @uptown_count ||= Neighborhood.nb_buildings_count(pop_neighborhoods,
                                                      view_context.uptown_sub_borough)
  end

  def brooklyn_count
    @brooklyn_count ||= Building.city_count(pop_nb_buildings,'Brooklyn',
                                            view_context.brooklyn_sub_borough)
  end

  def queens_count
    @queens_count ||= Building.city_count(pop_nb_buildings,'Queens',
                                          view_context.queens_sub_borough)
  end

  def bronx_count
    @bronx_count ||= Building.city_count(pop_nb_buildings, 'Bronx')
  end

  def pop_nb_buildings
    @pop_nb_buildings ||= Building.all #select(:city, :neighborhood)
  end

  def pop_neighborhoods
    @pop_neighborhoods ||= Neighborhood.select(:name, :buildings_count)
  end

  def after_sign_up_path_for(_resource)
    save_review
  end

  def after_sign_in_path_for(_resource)
    save_review
	end

  def wicked_pdf_options(file_name, template)
    { 
      pdf:              file_name,  template:       template,
      formats:          [:html],    page_size:      'A4',
      page_height:      250,        page_width:     300,
      encoding:         'utf-8',    orientation:    'Landscape',
      print_media_type: true,       outline: { outline:  true },
      layout: 'pdf',                show_as_html: params[:debug].present?,
      margin: { top: 20, left: 30, right: 30, bottom: 30 },
      footer: { content: footer_html, :encoding => 'utf-8' }
    }
  end

	private

  def set_layout
    if action_name == 'index' && controller_name == 'home'
      'home'
    elsif action_name == 'search' && controller_name == 'home'
      'search'
    else
      'application'
    end
  end

  def footer_html
    ERB.new(pdf_template).result(binding)
  end

  def pdf_template
    File.read("#{Rails.root}/app/views/layouts/pdf/footer.html.erb")
  end

  def controllers
    ['users/sessions', 'users/registrations', 'buildings', 'reviews']
  end

  def actions
    %w(new contribute index)
  end

  def save_review
    if session[:form_data].present?
      building_data = session[:form_data]['building']
      object_type   = session[:object_type]
      if object_type.present? && object_type == 'building'
        user_id   = current_user&.id
        building  = Building.new(building_data.merge(user_id: user_id))
        if building.save
          flash[:notice] = 'Building created successfully.'
          sign_in_redirect_path(building, session)
        end
      elsif object_type.present? && object_type == 'unit' && building_data.present?
        building = Building.find_by_building_street_address(building_data['building_street_address'])
        if (unit = building.created_unit(session, building_data))
          flash[:notice] = 'Unit created successfully.'
          sign_in_redirect_path(unit, session)
        end
      else
        reviewable = find_reviewable
        form_data  = session[:form_data]
        if reviewable.create_review(current_user, form_data, form_data['review'])
          flash[:notice] = 'Review Created Successfully.'
          session[:form_data], session[:after_contribute] = nil, 'reviews'
          if reviewable.kind_of? Building 
            return building_path(reviewable)
          else
            return unit_path(reviewable)
          end
        end
      end
    else
      flash[:notice] = 'Signed in successfully'
      session[:return_to] || root_path
    end
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

  def sign_in_redirect_path object, session
    return SignInRedirect.redirect_path(session: session, object: object)
  end

  def allow_iframe_requests
    response.headers.delete('X-Frame-Options')
  end
	
	def find_reviewable
    session[:form_data].each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
  end

  before_action :update_last_sign_in_at

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
