module BuildingReviews
	include Rails.application.routes.url_helpers
	
  def building_reviews
    self.reviews.includes(:user, :uploads).order(created_at: :desc)
  end

	def create_review current_user, form_params, review_params
		review 				 = self.reviews.build(review_params)
    review.user_id = current_user.id
    if review.save
      rating_score = form_params['score']
      udid         = form_params['upload_uid']
      review.set_imageable(udid) if udid.present?
      review.set_score(rating_score, self, current_user)
      review.set_votes(form_params['vote'], current_user, self)
    end
	end

	def default_url_options
    {}
  end
end