class Review < ActiveRecord::Base
	resourcify
  belongs_to :reviewable, polymorphic: true
  belongs_to :user

  validates :pros,:cons, :presence => true, length: { minimum: 10, :message => 'You must enter at least 10 words' } #, if: :can_validate?
  #validates_presence_of :pros, :message => 'Please add pros.'
  #validates_presence_of :cons, :message => 'Please add cons.'
  #validates_presence_of :review_title, :message => 'Please add review title.'
  #validates_presence_of :tenant_status, :message => 'Please select a reviewer type'
  #validates_presence_of :stay_time, :message => 'Please select number of years in residence.'
  
  # def can_validate?
  #   true
  # end
  validates_acceptance_of :tos_agreement, :allow_nil => false, :accept => true, :on => :create
  #validates :agreement, acceptance: { accept: true }

  after_destroy :destroy_dependents

  #reviewer
  def user_name
  	self.user.name ? self.user.name : self.user.email[/[^@]+/]
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
