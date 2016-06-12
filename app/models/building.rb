class Building < ActiveRecord::Base
  validates :building_name, presence: true
  validates :building_street_address, presence: true
  
  ratyrate_rateable "building"
  
  has_many :reviews, as: :reviewable
  has_many :units
  has_many :uploads, as: :imageable
  accepts_nested_attributes_for :uploads, :allow_destroy => true

  has_attached_file :photo, styles: { large: "600x600>", medium: "400x400>", thumb: "100x100>", small: "32x32>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  geocoded_by :building_street_address
  after_validation :geocode 

  def self.search(term)
    if term
      self.where("building_name LIKE ? or building_street_address LIKE ?", "%#{term}%", "%#{term}%")
    else
      self.all
    end
  end
end
