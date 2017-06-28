class Review < ActiveRecord::Base
	resourcify
  belongs_to :reviewable, polymorphic: true
  belongs_to :user
  has_many :useful_reviews
  has_many :review_flags
  validates :pros,:cons, :presence => true, length: { minimum: 10, :message => 'You must enter at least 10 words' } #, if: :can_validate?
  
  validates :tos_agreement, :allow_nil => false, :acceptance => { :accept => true }, :on => :create #, message: 'Terms not accepted.'
  
  after_destroy :destroy_dependents

  #reviewer
  def user_name
  	self.user.name ? self.user.name : self.user.email[/[^@]+/]
  end

  def property_name
    property = self.reviewable
    if property.kind_of? Building
      property.building_name ? property.building_name : property.building_street_address
    elsif property.kind_of? Unit
      property.name
    end
  end

  private
  #To remove rating and votes
  def destroy_dependents
    Vote.where(review_id: self.id).destroy_all
    rate = Rate.where(review_id: self.id).destroy_all
    #update stars
    rateable_id = self.reviewable_id
    rateable_type = self.reviewable_type
    rating_cache = RatingCache.where(cacheable_id: rateable_id)
    rateables = Rate.where(rateable_id: rateable_id, rateable_type: rateable_type)
    RatingCache.update_rating_cache(rating_cache, rateables)
  end

end
