# == Schema Information
#
# Table name: reviews
#
#  id               :integer          not null, primary key
#  review_title     :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  building_id      :integer
#  user_id          :integer
#  reviewable_id    :integer
#  reviewable_type  :string
#  building_address :string
#  tenant_status    :string
#  resident_to      :string
#  pros             :string
#  cons             :string
#  other_advice     :string
#  anonymous        :boolean          default(FALSE)
#  tos_agreement    :boolean          default(FALSE)
#  resident_from    :string
#  scraped          :boolean          default(FALSE)
#

class Review < ActiveRecord::Base
	resourcify
  belongs_to :reviewable, polymorphic: true
  belongs_to :user
  has_many :useful_reviews
  has_many :review_flags
  
  include Imageable
  include PgSearch
  
  validates :tos_agreement, :allow_nil => false, :acceptance => { :accept => true }, :on => :create #, message: 'Terms not accepted.'
  
  after_destroy :destroy_dependents

  default_scope { order('created_at DESC') }

  pg_search_scope :search_query, against: [:review_title, :pros, :cons],
     :using => { :tsearch => { prefix: true } }

  filterrific(
   default_filter_params: { },
   available_filters: [
     :search_query
    ]
  )

  #reviewer
  def user_name
  	self.user.name ? self.user.name : self.user.email[/[^@]+/]
  end

  def property_name
    if reviewable_object.kind_of? Building
      reviewable_object.name ? reviewable_object.name : reviewable_object.building_street_address
    elsif reviewable_object.kind_of? Unit
      reviewable_object.name
    end
  end

  def reviewable_object
    self.reviewable
  end

  def property_address
    if reviewable_object.kind_of? Building
      "#{reviewable_object.street_address} #{reviewable_object.zipcode}"
    elsif reviewable_object.kind_of? Unit
      "#{reviewable_object.building.street_address} #{reviewable_object.building.zipcode}"
    end
  end

  def set_votes vote, current_user, reviewable
    if vote == 'true'
      vote = current_user.vote_for(reviewable)
    else
      vote = current_user.vote_against(reviewable)
    end
    vote.update(review_id: id) if vote.present?
  end

  def set_score score_hash, reviewable, current_user
    score_hash.keys.each do |dimension|
      # params[dimension] => score
      current_user.create_rating(score_hash[dimension], reviewable, id, dimension)
    end
  end

  # def save_images review_attachments
  #   review_attachments['image'].each do |img|
  #     self.uploads.create!(image: img)
  #   end
  # end

  def set_imageable uid
    Upload.where(file_uid: uid).update_all(imageable_id: self.id, imageable_type: 'Review')
  end

  private
  def update_building_reviews_count
    revieable = self.reviewable
    revieable.update(reviews_count: revieable.reviews_count - 1) if revieable.reviews_count > 0
  end
  #To remove rating and votes
  def destroy_dependents
    update_building_reviews_count
    Vote.where(review_id: self.id).destroy_all
    rate = Rate.where(review_id: self.id).destroy_all
    #update stars
    #rateable_type = self.reviewable_type
    rating_caches = RatingCache.where(cacheable_id: self.reviewable_id, cacheable_type: self.reviewable_type)
    #rateables = Rate.where(dimension: 'building', rateable_id: rateable_id, rateable_type: rateable_type)
    
    #updating avg ratign for all dimensions
    rating_caches.each do |rating_cache|
      RatingCache.update_rating_cache(rating_cache)
    end
  end

end
