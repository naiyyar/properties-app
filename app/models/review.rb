class Review < ActiveRecord::Base
	resourcify
  belongs_to :reviewable, polymorphic: true
  belongs_to :user
  has_many :useful_reviews
  has_many :review_flags
  include Imageable
  
  validates :tos_agreement, :allow_nil => false, :acceptance => { :accept => true }, :on => :create #, message: 'Terms not accepted.'
  
  after_destroy :destroy_dependents

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

  # def save_images review_attachments
  #   review_attachments['image'].each do |img|
  #     self.uploads.create!(image: img)
  #   end
  # end

  def set_imageable uid
    Upload.where(file_uid: uid).update_all(imageable_id: self.id, imageable_type: 'Review')
  end

  private
  #To remove rating and votes
  def destroy_dependents
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
