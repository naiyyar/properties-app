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

  geocoded_by :street_address
  after_validation :geocode

  #
  after_create :save_neighborhood
  after_update :update_neighborhood

  include PgSearch
  pg_search_scope :search, against: [:building_name, :building_street_address],
    :using => { :trigram => {
                  :threshold => 0.1
                }
              }
  pg_search_scope :text_search_by_building_name, against: [:building_name],
    :using => { :trigram => {
                  :threshold => 0.1
                }
              }
  
  pg_search_scope :search_by_street_address, against: [:building_street_address],
    :using => { :trigram => { :threshold => 0.1 } }

  pg_search_scope :text_search_by_city, against: [:city],
    :using => { :trigram => { :threshold => 0.1 } }

  DISTANCE = 8

  def zipcode=(val)
     write_attribute(:zipcode, val.gsub(/\s+/,''))
  end

  def street_address
    [building_street_address, city, state].compact.join(', ')
  end

  def self.text_search(term)
    if term.present?
      search(term)
    else
      self.all
    end
  end

  def self.text_search_by_zipcode search_term
    where('zipcode @@ :q', q: search_term)
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

  private

  def neighborhoods
    search = Geocoder.search([building.latitude, building.longitude])
    neighborhoods = nil
    if search.present?
      neighborhood = search.first.address_components[2]['long_name']
      if neighborhood == 'Midtown'
        address = self.building_street_address
        east_side = address.scan(Regexp.union(/E/,/East/,/east/))
        west_side = address.scan(Regexp.union(/W/,/West/,/west/))
        south_side = address.scan(Regexp.union(/S/,/South/,/south/))
        if east_side.present?
          neighborhoods = 'Midtown East'
        elsif west_side.present?
          neighborhoods = 'Midtown West'
        elsif south_side.present?
          neighborhoods = 'Midtown South'
        else
          neighborhoods = 'Midtown North'
        end
      else
        neighborhoods = neighborhood
      end
    end
    return neighborhoods
  end

  def save_neighborhood
    if neighborhoods.present?
      self.neighborhood = neighborhoods
      self.save
    end
  end

  def update_neighborhood
    self.update_columns(neighborhood: neighborhoods) if neighborhoods.present? and self.neighborhood.blank?
  end

end
