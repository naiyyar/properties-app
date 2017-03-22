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

  #reviewer
  def user_name
  	self.user.name ? self.user.name : self.user.email[/[^@]+/]
  end
end
