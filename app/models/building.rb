class Building < ActiveRecord::Base
  acts_as_voteable
  validates :building_street_address, presence: true
  resourcify
  ratyrate_rateable "building"
  
  has_many :reviews, as: :reviewable
  has_many :units,  :dependent => :destroy
  has_many :uploads, as: :imageable
  accepts_nested_attributes_for :uploads, :allow_destroy => true
  accepts_nested_attributes_for :units, :allow_destroy => true

  has_attached_file :photo, styles: { large: "600x600>", medium: "400x400>", thumb: "100x100>", small: "32x32>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  geocoded_by :building_street_address
  after_validation :geocode 

  def self.search(term)
    if term
      self.where("building_name ILIKE ? or building_street_address ILIKE ? or city ILIKE ?", "%#{term}%", "%#{term}%", "%#{term}%")
    else
      self.all
    end
  end

  def fetch_or_create_unit params
    unit = Unit.new(params.values[0])
    unit.building_id = self.id
    unit.save
    return unit
  end
end
