# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  provider               :string
#  uid                    :string
#  image_url              :string
#  avatar_file_name       :string
#  avatar_content_type    :string
#  avatar_file_size       :integer
#  avatar_updated_at      :datetime
#  phone                  :string
#  about_me               :text
#  mobile                 :string
#

class User < ApplicationRecord
  include ActiveModel::Validations::HelperMethods
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
  
  rolify
  ratyrate_rater
  acts_as_voter
  
  has_many :reviews
  has_many :buildings
  has_many :units
  has_many :authorizations
  has_many :useful_reviews
  has_many :review_flags
  has_many :favorites, as: :favoriter, dependent: :destroy

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

  has_attached_file :avatar, styles: { medium: '300x300>', thumb: '100x100>' }
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  

  #methods
  def slug_candidates
    [
      :name,
      [:name, :user_email]
    ]
  end

  def user_email
    email.split('@')[0]
  end

  def saved_obejct? obejct
    true
  end

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
    
    if provider_image.present? 
      @avatar_url = provider_image
    elsif self.avatar.present?
      @avatar_url = self.avatar.url(:medium)
    else
      @avatar_url = 'user-missing.png'
    end
    @avatar_url
  end

  def user_name
    self.name.present? ? self.name : self.email[/[^@]+/]
  end

  def property_owner? object
    self.id == object.user_id
  end

  def create_rating score, rateable, review_id, dimension=nil
    rate = Rate.new
    rate.rater_id = self.id
    rate.rateable_id = rateable.id
    rate.rateable_type = rateable.class.name
    rate.dimension = dimension #rateable.class.name.downcase
    rate.stars = score
    rate.review_id = review_id
    rate.save

    #populate rating cache table
    rating_caches = RatingCache.where(cacheable_id: rateable.id, dimension: dimension)
    rateables = Rate.where(rateable_id: rateable.id, rateable_type: rateable.class.name, dimension: dimension)
    if rating_caches.present?
      #updating if rateable is already present
      rating_caches.each do |rating_cache|
        RatingCache.update_rating_cache(rating_cache)
      end
    else
      rating_cache = RatingCache.new
      rating_cache.cacheable_id = rateable.id
      rating_cache.cacheable_type = rateable.class.name
      rating_cache.dimension = dimension #rateable.class.name.downcase
      rating_cache.avg = rateables.sum(:stars)/rateables.count
      rating_cache.qty = rateables.count
      rating_cache.save
      #updating avg in building table
      rating_cache.update_building_avg if rating_cache.dimension == 'building'
    end

  end

  def favorite?(favorable)
    favorites.find_by(favorable_id: favorable.id, favorable_type: favorable.class.base_class.name).present?
  end  

  def favorite(favorable)
    unless favorite?(favorable)
      favorites.create(favorable_id: favorable.id, favorable_type: favorable.class.base_class.name)
    end
  end

  def unfavorite(favorable)
    records = favorites.find_by(favorable_id: favorable.id, favorable_type: favorable.class.base_class.name)
    records.try(:destroy)
  end

  # def should_generate_new_friendly_id?
  #   name_changed?
  # end

end
