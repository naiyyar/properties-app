class User < ActiveRecord::Base
  include ActiveModel::Validations::HelperMethods
  rolify
  ratyrate_rater
  acts_as_voter
  
  has_many :reviews
  has_many :buildings
  has_many :units
  has_many :authorizations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, on: :create
  #validates_email_realness_of :email
  #validates_email_format_of :email, :message => 'is not looking good'
  
  SOCIALS = {
    facebook: 'Facebook',
    google_oauth2: 'Google',
    linkedin: 'Linkedin'
  }

  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100>' }, default_url: '/assets/user-missing.png'
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  

  #methods

  def self.from_omniauth(auth, current_user)
    authorization = Authorization.where(:provider => auth.provider, 
                                        :uid => auth.uid).first_or_initialize
    if authorization.user.blank?
      user = current_user || User.where('email = ?', auth["info"]["email"]).first
      if user.blank?
        user = User.new
        user.email = auth.info.email
        user.password = Devise.friendly_token[0,20]
        user.name = auth.info.name
       #if auth.provider == "twitter" 
       #  user.save(:validate => false) 
       #else
         user.save
       #end
      end
      authorization.name = auth.info.name
      authorization.user_id = user.id
      authorization.image_url = auth.info.image
      authorization.save
    end
    authorization.user
  end

  def profile_image provider=nil
    if provider == 'Google'
      provider = 'google_oauth2'
    else
      provider = 'facebook'
    end
    authorizations = self.authorizations.where(provider: provider)
    provider_image = authorizations.last.image_url if authorizations.present?
    provider_image.present? ? provider_image : self.avatar
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
      RatingCache.update_rating_cache(rating_cache, rateables)
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
