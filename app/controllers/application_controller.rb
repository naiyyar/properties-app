class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_filter :allow_iframe_requests
  after_filter :store_location, except: [:auto_search]
  before_action :popular_neighborhoods

  def store_location
    # store last url as long as it isn't a /users path
    session[:return_to] = request.fullpath unless request.fullpath =~ /\/users/
    session[:contribution_for] = params[:contribution]
    session[:search_term] = params['buildings-search-txt']
  end

  def popular_neighborhoods
    @manhattan_neighborhoods = view_context.manhattan_neighborhoods
  end

  def after_sign_up_path_for(resource)
    save_review
  end

  def after_sign_in_path_for(resource)
    save_review
	end

	private

  def save_review
    if session[:form_data].present?
      if session[:object_type].present? and session[:object_type] == 'building'
        building = Building.create(session[:form_data]['building'])
        building.update(user_id: current_user.id) if current_user.present?
        flash_message = 'Building created successfully.'
        sign_in_redirect_path(building, flash_message)
      elsif session[:object_type].present? and session[:object_type] == 'unit' and session[:form_data]['building'].present?
        building = Building.find_by_building_street_address(session[:form_data]['building']['building_street_address'])
        session[:form_data]['building']['units_attributes']['0']['building_id'] = building.id if building.present?
        unit = Unit.find(session[:form_data]['unit_id']) if session[:form_data]['unit_id'].present?
        unit_params = session[:form_data]['building']['units_attributes']['0']
        if unit.present?
          @unit = unit.update(unit_params)
          @unit_object = unit
        else
          @unit = Unit.create(unit_params)
          @unit_object = @unit
          flash_message = 'Unit created successfully.'
        end
        
        sign_in_redirect_path(@unit_object, flash_message)
      else
        reviewable = find_reviewable
        review = reviewable.reviews.build(session[:form_data]['review'])
        review.user_id = current_user.id
        rating_score = session[:form_data]['score']
        if session[:form_data]['vote'] == 'true'
          vote = current_user.vote_for(reviewable)
        else
          vote = current_user.vote_against(reviewable)
        end
        
        udid = session[:form_data]['upload_uid']
        session[:form_data] = nil
        session[:after_contribute] = 'reviews'
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
      if session[:contribution_for] == 'building_photos' && session[:search_term].present?
        "/uploads/new?buildings-search-txt=#{session[:search_term]}&contribution=building_photos"
      elsif params[:contribution] == 'building_photos'
        "/uploads/new?buildings-search-txt=#{params['buildings-search-txt']}&contribution=building_photos"
      elsif session[:building_id].present?
        return "/uploads/new?building_id=#{session[:building_id]}"
      elsif session[:unit_id].present?
        return "/uploads/new?unit_id=#{session[:unit_id]}"
      else
        flash[:notice] = 'Signed in successfully'
        session[:return_to] || root_path
      end
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to redirect_back_or_default(root_url), notice: exception.message
  end

  def redirect_back_or_default(default)
    session[:return_to] || default
    #session[:return_to] = nil
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
            #return building_path(object)
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

  before_filter :update_last_sign_in_at

  protected

  def update_last_sign_in_at
    if user_signed_in? && !session[:logged_signin]
      sign_in(current_user, :force => true)
      session[:logged_signin] = true
    end
  end

end
