module BuildingReviews
	include Rails.application.routes.url_helpers
	
  def building_reviews
    self.reviews.includes(:user, :uploads, :reviewable).order(created_at: :desc)
  end

	def create_review session, current_user
		form_data 		 							= session[:form_data]
		review 				 							= self.reviews.build(form_data['review'])
    review.user_id 							= current_user.id
    rating_score   							= form_data['score']
    udid                        = form_data['upload_uid']
    session[:form_data]     		= nil
    session[:after_contribute]  = 'reviews'
    
    if review.save
      review.set_imageable(udid) if udid.present?
      review.set_score(rating_score, self, current_user)
      review.set_votes(form_data['vote'], current_user, self)
    end
	end

	def default_url_options
    {}
  end
end