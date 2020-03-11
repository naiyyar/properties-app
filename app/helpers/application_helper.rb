module ApplicationHelper
	
	def flash_class(flash_type)
    case flash_type.to_sym
      when :notice  then 'alert alert-success'
      when :info    then 'alert alert-info'
      when :error   then 'alert alert-danger'
      when :warning then 'alert alert-warning'
    end
  end

  def home_page?
    controller_name == 'home' && action_name == 'index'
  end

  def about_page?
    action_name == 'about'
  end
  
  def addvertise_page?
    action_name == 'advertise_with_us'
  end
  
  def contribute_page?
    action_name == 'contribute'
  end

  def hide_search_bar?
    home_page? || about_page? || addvertise_page? || contribute_page?
  end

  def current_user_profile_image
    @current_user_profile_image ||= current_user.profile_image(session[:provider])
  rescue
    nil
  end

  def search_bar(status)
    @search_bar_hidden == status ? 'hidden' : ''
  end

  def show_filters?
    params[:searched_by].present? || params[:filter].present? || params[:sort_by].present?
  end

  def header_center_col
    show_filters? ? '7' : '9'
  end

  def header_right_col
    show_filters? ? '4' : '2'
  end

  def clear_link_from_right
    show_filters? ? '6' : '13'
  end

  def current_view
    show_filters? ? 'split-view' : 'other-view'
  end

	def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

   def show_full_width_footer?
    @half_footer ? false : true
  end

end
