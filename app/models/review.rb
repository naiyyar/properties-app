class Review < ApplicationRecord
	resourcify
  include ImageableConcern
  include PgSearch::Model

  belongs_to :reviewable, polymorphic: true, counter_cache: true, :touch => true
  belongs_to :user, counter_cache: true
  
  pg_search_scope :search_query, against: [:review_title, :pros, :cons],
     :using => { :tsearch => { prefix: true } }

  filterrific(
   default_filter_params: { },
   available_filters: [
     :search_query
    ]
  )

  def self.buildings_reviews buildings, company_id=''
    CacheService.new( records: get_reviews(buildings.pluck(:id)),
                      key: "#{company_id}_buildings_reviews"
                    ).fetch
  end

  def self.get_reviews ids
    where(reviewable_id: ids, 
          reviewable_type: 'Building').includes(:user, :uploads, :reviewable)
  end

  # reviewer
  def user_name
  	self.user.name ? self.user.name : self.user.email[/[^@]+/]
  end

  def user_votes?
    user.votes.where(vote: true, review_id: id).present?
  end

  def marked_useful? user
    useful_reviews.where(user_id: user.id).present?
  end

  def marked_flag? user
    review_flags.where(user_id: user.id).present?
  end

  def property_name
    return if reviewable_object.blank?
    return reviewable_object.building_street_address unless reviewable_object.name
    reviewable_object.name
  end

  def reviewable_object
    @reviewable_object ||= self.reviewable
  end

  def set_votes vote, current_user, reviewable
    @vote  = if vote == 'true'
              current_user.vote_for(reviewable)
            else
              current_user.vote_against(reviewable)
            end
    @vote.update(review_id: id) if @vote.present?
  end

  def set_score score_hash, reviewable, current_user
    score_hash.keys.each do |dimension|
      # params[dimension] => score
      current_user.create_rating(score_hash[dimension], reviewable, id, dimension)
    end
  end

  def set_imageable uid
    Upload.where(file_uid: uid).update_all(imageable_id: self.id, imageable_type: 'Review')
  end

end
