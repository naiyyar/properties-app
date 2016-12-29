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

  pg_search_scope :text_search_by_neighborhood, against: [:neighborhood],
    :using => { :trigram => { :threshold => 0.1 } }


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

  def self.buildings_in_neighborhood neighborhoods
    where("neighborhood @@ :q" , q: "%#{neighborhoods}").to_a.uniq(&:building_street_address)
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

  def predifined_neighborhoods
    arr = []
    File.open("#{Rails.root}/public/neighborhoods.txt", "r").each_line do |line|
      arr << line.split(/\n/)
    end
    return arr.flatten
  end

  def midtown_neighborhoods
    ['Midtown East','Midtown North','Midtown South','Midtown West','Upper Manhattan','Upper West Side','Upper East Side']
  end

  private

  def neighborhoods
    search = Geocoder.search([latitude, longitude])
    neighborhoods = nil
    if search.present?
      #search for other neighborhoods except midtown
      search.each do |geo_result|
        neighborhood = geo_result.address_components_of_type(:neighborhood)
        if neighborhood.present?
          neighborhood = neighborhood.first['long_name']
          if predifined_neighborhoods.include? neighborhood
            neighborhoods = neighborhood
          end
        end
      end
      #search for midtown neighborhoods if nothing found for others
      if neighborhoods.blank?
        search.each do |geo_result|
        neighborhood = geo_result.address_components_of_type(:neighborhood)
        if neighborhood.present?
          neighborhood = neighborhood.first['long_name']
          if midtown_neighborhoods.include? neighborhood
            neighborhoods = neighborhood
          end
        end
      end
      end
      
      if neighborhoods.present?
        neighborhoods = neighborhoods
      else
        neighborhoods = search.first.address_components_of_type(:neighborhood)
        if neighborhoods.present?
          neighborhoods = neighborhoods.first['long_name']
        else
          neighborhoods = search.first.address_components_of_type(:locality).first['long_name']
        end
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
    self.update_columns(neighborhood: neighborhoods) if neighborhoods.present?
  end

end
