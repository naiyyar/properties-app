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

  include PgSearch
  pg_search_scope :search, against: [:building_name, :building_street_address],
    :using => { :trigram => {
                  :threshold => 0.1
                }
              }

  DISTANCE = 15

  def self.text_search(term)
    if term.present?
      search(term)
    else
      self.all
    end
  end

  def self.text_search_by_city search_term
    where('city @@ :q', q: search_term)
  end
  
  def self.text_search_by_building_name search_term
    where('building_name @@ :q', q: search_term)
  end

  def self.neighborhood_search_by_street_address search, params
    if search.types.include? 'street_address'
      @buildings = near(search.coordinates, Building::DISTANCE)
    else
      @buildings = where('building_street_address @@ :q', q: params[:term])
    end
    @buildings = @buildings.to_a.uniq(&:building_street_address)
  end

  def self.neighborhood_search_by_zipcode search, params
    if search.types.include? 'postal_code'
      near(search.coordinates, Building::DISTANCE).to_a.uniq(&:zipcode)
    else
      where('zipcode @@ :q', q: params[:term])
    end
  end

  def fetch_or_create_unit params
    unit = Unit.new(params.values[0])
    unit.building_id = self.id
    unit.save
    return unit
  end

  def unit_reviews_count
    count = 0
    self.units.each do |unit|
      count = count + unit.reviews.count
    end
    return count
  end

end
