class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session, except: :load_infobox

  before_action :allow_iframe_requests
  after_action  :store_location, unless: :skip_store_location
  before_action :popular_neighborhoods
  before_action :set_timezone, if: :user_signed_in?

  helper_method :browser_time_zone,
                :uptown_count,
                :brooklyn_count,
                :queens_count,
                :bronx_count

  def set_timezone
    Time.zone = current_user.time_zone
  end

  def browser_time_zone
    browser_tz = ActiveSupport::TimeZone.find_tzinfo(cookies[:timezone])
    # ActiveSupport::TimeZone.all.find{ |zone| zone.tzinfo == browser_tz } || Time.zone
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
    @brooklyn_count ||= Building.city_count(pop_nb_buildings,
                                            'Brooklyn',
                                            view_context.brooklyn_sub_borough)
  end

  def queens_count
    @queens_count ||= Building.city_count(pop_nb_buildings,
                                          'Queens',
                                          view_context.queens_sub_borough)
  end

  def bronx_count
    @bronx_count ||= Building.city_count(pop_nb_buildings, 'Bronx')
  end

  def after_sign_up_path_for(_resource)
    save_review
  end

  def after_sign_in_path_for(_resource)
    save_review
	end

  def wicked_pdf_options(file_name, template)
    { :pdf => file_name,
      :template    => template,
      :layout      => 'pdf',
      :formats     => [:html],
      :page_size   => 'A4',
      :page_height => 250,
      :page_width  => 300,
      :encoding    => 'utf-8',
      :show_as_html => params[:debug].present?, # renders html version if you set debug=true in URL
      :orientation  => 'Landscape',
      :print_media_type => true,
      outline: {   outline:  true },
      margin:  {     
                  top:    20,
                  left:   30,
                  right:  30,
                  bottom: 30
                },
      :footer => { 
                  content: footer_html,
                  :encoding => 'utf-8',
                }
    } 
  end

	private

  def footer_html
    ERB.new(pdf_template).result(binding)
  end

  def pdf_template
    File.read("#{Rails.root}/app/views/layouts/pdf/footer.html.erb")
  end

  def pop_nb_buildings
    @pop_nb_buildings ||= Building.select(:city, :neighborhood)
  end

  def pop_neighborhoods
    @pop_neighborhoods ||= Neighborhood.select(:name, :buildings_count)
  end

  def controllers
    ['users/sessions', 'users/registrations', 'buildings', 'reviews')
  end

  def actions
    %w(new contribute index)
  end

  # OPTIMIZE ... Too many lines
  def save_review
    # SaveReview.new(form_data: session[:form_data])
    if session[:form_data].present?
      building_data = session[:form_data]['building']
      if session[:object_type].present? && session[:object_type] == 'building'
        building = Building.create(building_data)
        building.update(user_id: current_user.id) if current_user
        flash_message = 'Building created successfully.'
        sign_in_redirect_path(building, flash_message)
      elsif session[:object_type].present? && session[:object_type] == 'unit' && building_data.present?
        unit_attributes = building_data['units_attributes']['0']
        unit_id         = session[:form_data]['unit_id']
        building        = Building.find_by_building_street_address(building_data['building_street_address'])
        unit_attributes['building_id'] = building.id if building.present?
        unit            = Unit.find(unit_id) if unit_id.present?
        unit_params     = unit_attributes
        if unit.present?
          @unit         = unit.update(unit_params)
          @unit_object  = unit
        else
          @unit         = Unit.create(unit_params)
          @unit_object  = @unit
          flash_message = 'Unit created successfully.'
        end
        sign_in_redirect_path(@unit_object, flash_message)
      else
        reviewable      = find_reviewable
        review          = reviewable.reviews.build(session[:form_data]['review'])
        review.user_id  = current_user.id
        rating_score    = session[:form_data]['score']
        if session[:form_data]['vote'] == 'true'
          vote = current_user.vote_for(reviewable)
        else
          vote = current_user.vote_against(reviewable)
        end
        
        udid                        = session[:form_data]['upload_uid']
        session[:form_data]         = nil
        session[:after_contribute]  = 'reviews'
        if review.save
          review.set_imageable(udid) if udid.present?
          if rating_score.present? 
            rating_score.keys.each do |dimension|
              current_user.create_rating(rating_score[dimension], reviewable, review.id, dimension)
            end
          end

          if vote.present?
            vote.review_id = review.id
            vote.save
          end
          flash[:notice] = 'Review Created Successfully.'
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
      redirect_to '/404' #page_not_found_path
    end
  end

  def redirect_back_or_default(default)
    session[:return_to] || default
  end

  def sign_in_redirect_path object, flash_message
    if session[:form_data].present?
      if session[:form_data]['contribution'].present?
        flash[:notice] = flash_message
        case session[:form_data]['contribution']
        when 'building_photos'
          return "/uploads/new?building_id=#{object.id}"
        when 'unit_photos'
          return "/uploads/new?unit_id=#{object.id}"
        else
          if object.kind_of? Building 
            #Togoto Reviews path
            return user_steps_path(building_id: object.id, contribution_for: session[:form_data]['contribution'], contribution: session[:form_data]['contribution'])
          else
            return unit_path(object)
          end
        end
      else
        flash[:notice] = flash_message if flash_message.present?
        case session[:form_data]['unit_contribution']
        when 'unit_photos'
          return "/uploads/new?unit_id=#{object.id}"
        when 'unit_price_history'
          return "/user_steps/next_page?contribution_for=unit_price_history&unit_id=#{object.id}"
        when 'unit_amenities'
          return "/user_steps/next_page?contribution_for=unit_amenities&unit_id=#{object.id}"
        else
          return unit_path(object)
        end
      end
    else
      session[:return_to] || root_path
    end
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
