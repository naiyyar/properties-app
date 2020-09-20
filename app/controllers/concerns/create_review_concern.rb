module CreateReviewConcern
	extend ActiveSupport::Concern

	def after_sign_up_path_for(_resource)
    save_review
  end

  def after_sign_in_path_for(_resource)
    save_review
	end

	private

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

  def sign_in_redirect_path object, session
    return SignInRedirect.redirect_path(session: session, object: object)
  end

  def find_reviewable
    session[:form_data].each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
  end
end