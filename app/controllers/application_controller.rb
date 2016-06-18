class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
	  if session[:form_data].present?
	    reviewable = find_reviewable
      review = reviewable.reviews.build(session[:form_data]['review'])
      review.user_id = current_user.id
      
      if session[:form_data]['vote']
      	reviewable.liked_by current_user
    	else
				reviewable.downvote_from current_user
      end
      
      session[:form_data] = nil
      
      if review.save
        flash[:notice] = "Review Created Successfully."
        return building_path(reviewable)
      end

	  else
	    super
	  end
	end

	private
	
	def find_reviewable
    session[:form_data].each do |name, value|
      if name =~ /(.+)_id$/
          return $1.classify.constantize.find(value)
      end
    end
  end
end
