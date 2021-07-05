module ApplicationHelper
	include Pagy::Frontend
  
	def flash_class(flash_type)
    case flash_type.to_sym
      when :notice  then 'alert-success'
      when :info    then 'alert-info'
      when :error   then 'alert-danger'
      when :warning then 'alert-warning'
    end
  end

  def wrapper_classes
    "#{contribute_wrapper(params)} #{screen_class} #{@search_bar_hidden == :hidden ? 'mt0' : ''}"
  end

  def screen_class
    mobile? ? 'screen-sm' : 'screen-lg'
  end

  def mobile?
    browser.device.mobile?
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

  def authentication_page?
    controller_name == 'sessions' || controller_name == 'registrations'
  end

  def saved_buildings_page?
    action_name == 'saved_buildings'
  end

  def mob_header_bg_color_class_helper
    show_and_search_page_header? ? 'bg-blue' : 'bg-white'
  end

  # showing white header with logo
  def hide_search_bar?
    hide_hood_dropdown?
  end

  def hide_hood_dropdown?
    !show_and_search_page_header?
  end

  def show_and_search_page_header?
    search_page? || 
    building_show_page? || 
    management_show_page? || 
    featured_listing_show_page?
  end

  def current_user_profile_image
    @current_user_profile_image ||= current_user.profile_image(session[:provider])
  rescue
    nil
  end

  def search_bar(status)
    @search_bar_hidden == status ? 'd-none' : ''
  end

  def search_page? 
    show_filters?
  end

  def blog_view?
    params[:controller].include?('buttercms')
  end

  def building_show_page?
    action_name == 'show' && controller_name == 'buildings'
  end

  def featured_listing_show_page?
    action_name == 'show' && controller_name == 'featured_listings'
  end

  def management_show_page?
    action_name == 'show' && controller_name == 'management_companies'
  end

  def header_center_col
    show_filters? ? '6' : '8'
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

  def show_filters?
    params[:searched_by].present? || 
    params[:filter].present? || 
    params[:sort_by].present?
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

  def layout_stylesheet_link sheet_path
    stylesheet_link_tag sheet_path, media: 'all', as: 'style', rel: "preload stylesheet", crossorigin: "anonymous"
  end

  private
  
  def search_placeholder_input_styles
    return 'border: 0px solid #333; -webkit-appearance: none;' if mobile?
    'border: 0px solid #333; -webkit-appearance: none; box-shadow: 1px 1px 5px rgba(0,0,0,0.6);'
  end

  def search_placeholder_input_form_ctrl_class
    home_page? ? 'form-control' : ''
  end

end
