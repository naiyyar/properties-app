class Building < ActiveRecord::Base

  include PgSearch
  include Imageable
  acts_as_voteable
  resourcify
  ratyrate_rateable 'building'

  validates :building_street_address, presence: true
  validates_uniqueness_of :building_street_address, scope: [:zipcode]
  #validates_uniqueness_of :building_name, :allow_blank => true, :allow_nil => true

  belongs_to :user
  has_many :reviews, as: :reviewable
  has_many :units,  :dependent => :destroy
  
  accepts_nested_attributes_for :units, :allow_destroy => true

  default_scope { order('updated_at desc') }

  geocoded_by :street_address
  after_validation :geocode

  #callbacks
  after_create :save_neighborhood
  after_update :update_neighborhood

  #multisearchable
  PgSearch.multisearch_options = {
    :using => [:tsearch, :trigram, :dmetaphone],
    :ignoring => :accents
  }
  multisearchable :against => [:neighborhood, :building_name]

  #pgsearch
  pg_search_scope :search, against: [:building_name, :building_street_address],
     :using => { :tsearch => { prefix: true } }

  pg_search_scope :search_by_neighborhood, against: [:neighborhood],
     :using => {  :tsearch => { prefix: true }, 
                  :trigram=> { :threshold => 0.1 } 
                }
  pg_search_scope :search_by_pneighborhood, against: [:neighborhoods_parent, :building_name],
     :using => {  :tsearch => { prefix: true }, 
                  :trigram=> { :threshold => 0.2 } 
                }

  pg_search_scope :text_search_by_building_name, against: [:building_name],
                  :using => {:tsearch=> { prefix: true }, :trigram=> {
                  :threshold => 0.1
                }}

  pg_search_scope :search_by_street_address, against: [:building_street_address],
    :using => {:tsearch=> { prefix: true }, :trigram=> {
                  :threshold => 0.1
                }}

  pg_search_scope :text_search_by_city, against: [:city],
    :using => {:tsearch=> { prefix: true }, :trigram=> {
                  :threshold => 0.1
                }}

  def to_param
    if building_name.present?
      "#{id} #{building_name}".parameterize
    else
      "#{id} #{building_street_address}".parameterize
    end
  end

  #using regexp to put search string on top
  def self.search_by_neighborhoods(criteria)
    regexp = /#{criteria}/i; # case-insensitive regexp based on your string
    results = Building.search_by_neighborhood(criteria).order(:neighborhood).to_a.uniq(&:neighborhood)
    results.sort{|x, y| (x =~ regexp) <=> (y =~ regexp) } 
  end

  def self.search_by_pneighborhoods(criteria)
    regexp = /#{criteria}/i;
    results = Building.search_by_pneighborhood(criteria).order(:neighborhoods_parent).to_a.uniq(&:neighborhoods_parent)
    #results = order(:neighborhoods_parent).where("neighborhoods_parent ILIKE ?", "%#{criteria}%").to_a.uniq(&:neighborhoods_parent)
    results.sort{|x, y| (x =~ regexp) <=> (y =~ regexp) } 
  end

  def self.search_by_building_name(criteria)
    regexp = /#{criteria}/i;
    results = Building.text_search_by_building_name(criteria).order(:building_name).to_a.uniq(&:building_name)
    results.sort{|x, y| (x =~ regexp) <=> (y =~ regexp) } 
  end

  def self.text_search_by_zipcode query
    where("similarity(zipcode, ?) > 0.5", query)
  end

  def recommended_percent
    Vote.recommended_percent(self)
  end

  def zipcode=(val)
    write_attribute(:zipcode, val.gsub(/\s+/,''))
  end

  def street_address
    [building_street_address, city, state].compact.join(', ')
  end

  def building_name_or_address
    building_name.present? ? building_name : building_street_address
  end

  def rent_information
    info_count = 0
    self.units.each do |unit|
      info_count += unit.rental_price_histories.count
    end
    info_count
  end

  def self.text_search(term)
    if term.present?
      search(term)
    else
      self.all
    end
  end

  def no_of_units
    self.number_of_units.present? ? self.number_of_units : self.units.count
  end

  def reviews_count
    self.reviews.present? ? self.reviews.count : 0
  end

  def self.buildings_in_neighborhood params
    where("neighborhood @@ :q or neighborhoods_parent @@ :q" , q: "%#{params[:neighborhoods]}").paginate(:page => params[:page], :per_page => 20) #.to_a.uniq(&:building_street_address)
  end

  def self.buildings_in_city params, city
    where("city @@ :q" , q: city).paginate(:page => params[:page], :per_page => 20) #.to_a.uniq(&:building_street_address)
  end

  def rating_cache
    RatingCache.where(cacheable_id: self.id, cacheable_type: 'Building') 
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

  def unit_rent_summary_count
    unit_rent_summary_count = 0
    self.units.each do |unit|
      unit_rent_summary_count += unit.rental_price_histories.count
    end
    unit_rent_summary_count
  end

  def unit_reviews_count
    unit_review_count = 0
    self.units.each do |unit|
      unit_review_count += unit.reviews.count
    end
    unit_review_count
  end

  def photos
    building_counts = self.uploads.count
    unit_counts = 0
    self.units.each do |unit|
      unit_counts += unit.uploads.count
    end
    return building_counts + unit_counts
  end

  #finding similar properties may be on the basis amenities
  def similar_properties
    buildings = Building.where('id <> ?', self.id)
  end

  #child neighbohoods
  def predifined_neighborhoods
    arr = []
    File.open("#{Rails.root}/public/neighborhoods.txt", "r").each_line do |line|
      arr << line.split(/\n/)
    end
    return arr.flatten
  end

  #Parent neighbohoods
  def parent_neighborhoods
    [ 'Midtown East','Midtown North',
      'Midtown South','Midtown West','Upper West Side',
      'Upper East Side','Lower East Side',
      'Greenwich Village','Flatbush - Ditmas Park'
    ]
  end

  def grandparent_neighborhoods
    ['Lower Manhattan', 'Upper Manhattan', 'Midtown']
  end

  private

  def neighborhoods
    search = Geocoder.search([latitude, longitude])
    neighborhood1 = neighborhood2 = neighborhood3 = ''
    if search.present?
      #search for child neighborhoods
      search[0..4].each do |geo_result|
        #finding neighborhood
        neighborhood = geo_result.address_components_of_type(:neighborhood)
        if neighborhood.present?
          neighborhood = neighborhood.first['long_name']
          #checking main neighborhood
          if predifined_neighborhoods.include? neighborhood
            neighborhood1 = neighborhood
            neighborhood2 = neighborhood if neighborhood2.blank?
          elsif parent_neighborhoods.include? neighborhood #checking parent of main neighborhood
            neighborhood2 = neighborhood
            neighborhood1 = neighborhood if neighborhood1.blank?
          elsif grandparent_neighborhoods.include? neighborhood #checking grandparent of main neighborhood
            neighborhood3 = neighborhood
            neighborhood1 = neighborhood if neighborhood1.blank?
            neighborhood2 = neighborhood if neighborhood2.blank?
          end
          #end if
        end

      end #end search loop
      
    end #end seaech if

    return neighborhood1, neighborhood2, neighborhood3
  end

  def save_neighborhood
    if neighborhoods.present?
      self.neighborhood = neighborhoods[0]
      self.neighborhoods_parent = neighborhoods[1]
      self.neighborhood3 = neighborhoods[2]
      self.save
    end
  end

  def update_neighborhood
    if neighborhoods.present?
      #if self.neighborhood != neighborhoods[0] or self.neighborhoods_parent != neighborhoods[1]
      self.update_columns(neighborhood: neighborhoods[0], neighborhoods_parent: neighborhoods[1], neighborhood3: neighborhoods[2] )
      #end
    end
  end

end
