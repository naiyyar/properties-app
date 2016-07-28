class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
	  if session[:form_data].present?
	    reviewable = find_reviewable
      review = reviewable.reviews.build(session[:form_data]['review'])
      review.user_id = current_user.id

      if session[:form_data]['score']
      	current_user.create_rating(session[:form_data]['score'], reviewable)
      end
      
      if session[:form_data]['vote'] == 'true'
        current_user.vote_for(reviewable)
    	else
        current_user.vote_against(reviewable)
      end
      
      session[:form_data] = nil
      
      if review.save
        flash[:notice] = "Review Created Successfully."
        if reviewable.kind_of? Building 
          return building_path(reviewable)
        else
          return unit_path(reviewable)
        end
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
