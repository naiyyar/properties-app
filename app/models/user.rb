class User < ActiveRecord::Base
  rolify
  ratyrate_rater
  acts_as_voter
  
  has_many :reviews
  has_many :buildings
  has_many :units

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  

  #methods

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image_url = auth.info.image # assuming the user model has an image
    end
  end

  def user_name
    self.name.present? ? self.name : self.email[/[^@]+/]
  end

  def property_owner? object
    self.id == object.user_id
  end

  def create_rating score, rateable, review_id = nil
    rate = Rate.new
    rate.rater_id = self.id
    rate.rateable_id = rateable.id
    rate.rateable_type = rateable.class.name
    rate.dimension = rateable.class.name.downcase
    rate.stars = score
    rate.review_id = review_id
    rate.save

    #populate rating cache table
    rating_cache = RatingCache.where(cacheable_id: rateable.id)
    rateables = Rate.where(rateable_id: rateable.id, rateable_type: rateable.class.name)
    if rating_cache.present?
      #updating if rateable is already present
      rating_cache = rating_cache.first
      rating_cache.avg = rateables.sum(:stars)/rateables.count
      rating_cache.qty = rateables.count
      rating_cache.save
    else
      rating_cache = RatingCache.new
      rating_cache.cacheable_id = rateable.id
      rating_cache.cacheable_type = rateable.class.name
      rating_cache.dimension = rateable.class.name.downcase
      rating_cache.avg = rateables.sum(:stars)/rateables.count
      rating_cache.qty = rateables.count
      rating_cache.save
    end
  end

end
