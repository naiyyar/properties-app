class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :allow_iframe_requests
  after_filter :store_location

  def store_location
    # store last url as long as it isn't a /users path
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
    session[:contribution_for] = params[:contribution]
    session[:search_term] = params['buildings-search-txt']
  end

  def after_sign_in_path_for(resource)
	  if session[:form_data].present?
	    reviewable = find_reviewable
      review = reviewable.reviews.build(session[:form_data]['review'])
      review.user_id = current_user.id
      rating_score = session[:form_data]['score']
      if session[:form_data]['vote'] == 'true'
        vote = current_user.vote_for(reviewable)
    	else
        vote = current_user.vote_against(reviewable)
      end
      session[:form_data] = nil
      
      if review.save
        if rating_score.present?
          current_user.create_rating(rating_score, reviewable, review.id)
        end

        if vote.present?
          vote.review_id = review.id
          vote.save
        end
        flash[:notice] = "Review Created Successfully."
        if reviewable.kind_of? Building 
          return building_path(reviewable)
        else
          return unit_path(reviewable)
        end
      end
	  else
	    if session[:contribution_for] == 'building_photos'
        search_text = session[:search_term]
        "/uploads/new?buildings-search-txt=#{search_text}"
      else
        session[:previous_url] || root_path
      end
	  end
    
	end

	private

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

end
