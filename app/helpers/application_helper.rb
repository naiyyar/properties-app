module ApplicationHelper
	
	def flash_class(flash_type)
    case flash_type.to_sym
      when :notice then "alert alert-success"
      when :info then "alert alert-info"
      when :error then "alert alert-danger"
      when :warning then "alert alert-warning"
    end
  end

  def current_user_profile_image
    current_user.profile_image(session[:provider]) rescue nil
  end

  def search_bar(status)
    @search_bar_hidden == status ? 'hidden' : ''
  end

  def show_filters?
    params[:searched_by].present? or params[:filter].present? or params[:sort_by].present?
  end

	def resource_name
    :user
  end

  def show_full_width_footer?
    if @half_footer
      false
    else
      true
    end
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

end
