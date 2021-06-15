class Building < ApplicationRecord
  acts_as_voteable
  resourcify

  # Modules
  include ImageableConcern
  include FavoritableConcern
  include RateableConcern
  include PgSearch::Model
  include SaveNeighborhood
  include BuildingReviews
  include Voteable
  include BedRanges
  include Tourable

  # Search and filtering
  extend Search::BuildingSearch
  extend Search::BuildingFilters
  extend Search::BuildingSorting
  extend Search::PopularSearches
  extend Search::RedoSearch

  # constants
  RANGE_PRICE = ['$', '$$', '$$$', '$$$$'].freeze
  COLIVING_NUM = 9
  NO_PHOTO = 'no-photo.jpg'
  
  PENTHOUSES_MIN_PRICE = 8000
  
  BEDROOMS    = [
                 ['0',  'Studio'  ],
                 ['1',  '1 Bed'   ],
                 ['2',  '2 Bed'   ],
                 ['3',  '3 Bed'   ],
                 ['4',  '4+ Bed'  ],
                 ['9',  'CoLiving']
                ].freeze
  CITIES      = ['New York', 'Brooklyn', 'Bronx', 'Queens']
  AMENITIES   = [:doorman, :courtyard, :laundry_facility, :parking, :elevator, :roof_deck, :swimming_pool,
                :management_company_run, :gym, :live_in_super,:pets_allowed_cats,
                :pets_allowed_dogs, :walk_up,:childrens_playroom,:no_fee]
  
  ATTRS       = [:id, :building_name, :building_street_address, :latitude, :longitude, :zipcode, :reviews_count, :web_url, 
                 :email, :active_email, :active_web,:min_listing_price, :max_listing_price, :uploads_count, :price,
                 :featured_buildings_count, :city, :state, :building_type, :neighborhood, :neighborhoods_parent, 
                 :neighborhood3, :listings_count, :updated_at, :bedroom_types]
  
  
  
  ratyrate_rateable 'building','cleanliness','noise','safe','health','responsiveness','management'

  validates :building_street_address, presence: true
  validates_uniqueness_of :building_street_address, scope: [:zipcode], on: :create

  # From some buildings when submitting reviews getting
  # Error: undefined method `address=' for #<Building
  attr_accessor :address, :min_price, :max_price, :act_listings

  belongs_to :user, optional: true
  belongs_to :management_company, touch: true, optional: true
  has_many :reviews, as: :reviewable
  # has_one  :featured_comp,          foreign_key: :building_id,  dependent: :destroy
  has_many :featured_comp_buildings
  has_many :featured_comps, through: :featured_comp_buildings, dependent: :destroy
  has_many :featured_buildings, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :listings, -> {where('listings.active' => true)}, foreign_key: :building_id, dependent: :destroy
  has_many :past_listings, foreign_key: :building_id, dependent: :destroy
  has_many :units, dependent: :destroy
  accepts_nested_attributes_for :units, :allow_destroy => true

  # Scopes
  scope :order_by_id_pos,    -> (ids) { where(id: ids.uniq).order("array_position(ARRAY[#{ids.join(',')}], buildings.id)") }
  scope :updated_recently,   -> { order({listings_count: :desc, building_name: :asc, building_street_address: :asc}) }
  scope :order_by_min_rent,  -> { order('min_listing_price ASC, listings_count DESC') }
  scope :order_by_max_rent,  -> { order('max_listing_price DESC NULLS LAST, listings_count DESC') }
  scope :order_by_min_price, -> { order({price: :asc, listings_count: :desc, building_name: :asc, building_street_address: :asc}) }
  scope :order_by_max_price, -> { order('price DESC NULLS LAST, listings_count DESC, building_name ASC, building_street_address ASC') }

  scope :saved_favourites, -> (user) do
    joins(:favorites).where('buildings.id = favorites.favorable_id AND favorites.favoriter_id = ?', user.id )
  end
  scope :building_photos, -> (buildings) do 
    buildings.joins(:uploads).where('buildings.id = uploads.imageable_id AND imageable_type = ?', 'Building')
  end

  scope :buildings_with_active_comps, -> (building_id) do
    joins(:featured_comps).where('featured_comps.building_id = ? AND featured_comps.active is true', building_id)
  end

  scope :with_active_listing, -> { where('listings_count > ?', 0) }
  scope :with_listings_bed, -> (beds) { where('listings.bed in (?) AND listings.active is true', beds) }
  scope :between_prices, -> (min, max) { where('listings.rent >= ? AND listings.rent <= ?', min, max) }
  scope :join_with_listings,  -> { left_outer_joins(:listings).distinct
                                                                .select('buildings.*, COUNT(listings.*) as lists_count')
                                                                .group('buildings.id, listings.id')
                                    }
  scope :months_free, -> { where('listings.active is true AND listings.free_months > ?', 0)}
  scope :owner_paid, -> { where('listings.active is true AND listings.owner_paid is not null')}
  scope :rent_stabilize, -> { where('listings.active is true AND listings.rent_stabilize in (?)', ['t', 'true'])}
  
  scope :with_active_web, -> { where('active_web is true AND web_url is not null') }
  scope :with_active_email, -> { where('active_email is true AND email is not null') }
  scope :with_application_link, -> { where('show_application_link is true AND online_application_link is not null') }
  scope :with_schedule_tour, -> { where('schedule_tour_active is true AND schedule_tour_url is not null') }
  scope :with_pets, -> { where('pets_allowed_cats is true OR pets_allowed_dogs is true') }
  
  scope :random, -> (ids) { where(id: ids) }
  
  # popular searches
  scope :luxury_rentals, -> { with_amenities(['doorman', 'elevator']) }
  scope :penthouses_luxury_rentals, -> (ids) { where(id: ids) }
  scope :penthouse, -> { where('max_listing_price >= ?', PENTHOUSES_MIN_PRICE) }
  scope :with_bed, -> (beds) { where("bedroom_types @> ARRAY[?]::varchar[]", beds) }
  scope :with_amenities, -> (amenities) { where("amenities @> ARRAY[?]::varchar[]", amenities) }

  # pgsearch
  pg_search_scope :search, against: [:building_name, :building_street_address],
     :using => { :tsearch => { prefix: true } }

  pg_search_scope :search_query, against: [:building_name, :building_street_address],
     :using => { :tsearch => { prefix: true } }

  pg_search_scope :search_by_pneighborhood, against: [:neighborhoods_parent],
     :using => {  :tsearch => { prefix: true }, :trigram=> { :threshold => 0.1 } }

  pg_search_scope :text_search_by_city, against: [:city],
    :using => {:tsearch=> { prefix: true }, :trigram=> { :threshold => 0.2 } }

  pg_search_scope :search_by_zipcode, against: [:zipcode],
    :using => { :tsearch=> { prefix: true } }

  pg_search_scope :search_by_neighborhood, against: [:neighborhood, :neighborhoods_parent, :neighborhood3],
    :using => [:tsearch, :trigram]
  pg_search_scope :search_by_city, against: [:city]

  filterrific(
   default_filter_params: { },
   available_filters: [
     :search_query
    ]
  )

  # callbacks
  after_create :update_neighborhood_counts
  after_update :update_neighborhood_counts, :if => Proc.new{ |obj| obj.continue_call_back? }
  after_destroy :update_neighborhood_counts

  #
  geocoded_by :full_street_address
  after_validation :geocode

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  # delegates
  delegate :name, to: :management_company, prefix: true

  
  # Methods

  def to_param
    slug
  end

  def slug
    slug = building_name.present? ? "#{id} #{building_name}" : "#{id} #{building_street_address}"
    slug.parameterize
  end

  def continue_call_back?
    ( avg_rating_changed?          && 
      recommended_percent_changed? && 
      min_listing_price_changed?   && 
      max_listing_price_changed?)
  end

  def featured
    featured?
  end

  def featured?
    featured_buildings_count.to_i > 0
  end

  def property_type
    self.class.name
  end

  def active_comps
    @active_comps ||= featured_comps.active
  end

  def featured_comp_building_id
    self.id
  end

  def get_subway_lines
    CacheService.new( records: DistanceMatrixService.new(self).get_data,
                      key: "subway_lines_#{self.id}"
                    ).fetch
  end

  def cached_listings
    CacheService.new( records: self.listings,
                      key: "active_listings_#{self.id}"
                    ).fetch
  end

  def cached_past_listings
    CacheService.new( records: self.past_listings,
                      key: "past_listings_#{self.id}"
                    ).fetch
  end

  def get_listings filter_params, type='active', load_more_params={}
    Filter::Listings.new(self, 
                         load_more_params, 
                         type, 
                         filter_params).fetch_listings
  end

  def export_amenities
    amenities = []
    self.sorted_amenities.each do |amenity|
      value = Building.building_amenities[amenity.to_sym]
      amenities << (value == 'Elevator' ? "#{value}(#{elevator})" : value)
    end
    amenities.join(',')
  end

  def self.building_amenities 
    @building_amenities ||= BuildingAmenities.building_edit_amenities
  end

  def sorted_amenities
    @sorted_amenities ||= self.amenities.keep_if{|val| !val.empty?}.sort
  end

  def nearby_neighborhood
    return neighborhood3 if neighborhood3.present?
    neighborhoods_parent.present? ? neighborhoods_parent : neighborhood
  end

  def first_neighborhood
    neighborhood.present? ? neighborhood : neighborhoods_parent
  end

  def parent_neighbors
    if neighborhood.present? && neighborhoods_parent.present? && neighborhood3.present? 
      (neighborhoods_parent == neighborhood) ? neighborhood3 : neighborhoods_parent
    else
      neighborhood3.present? ? neighborhood3 : neighborhoods_parent
    end
  end

  def neighbohoods
    first_neighborhood.present? ? first_neighborhood : neighborhood3
  end

  def neighborhood_name
    neighbohoods
  end

  def name_with_address
    "#{name} #{street_address}"
  end

  def name
    self.building_name
  end

  def zipcode=(val)
    write_attribute(:zipcode, val.to_s.gsub(/\s+/,'')) if val.present?
  end

  def street_address
    address.compact.join(', ')
  end

  def full_street_address
    (address << zipcode).compact.join(', ')
  end

  def building_name_or_address
    building_name.present? ? building_name : building_street_address
  end

  alias_method :property_name_or_address, :building_name_or_address

  def formatted_city
    self.city.downcase.gsub(' ', '')
  end

  def prices
    !price.nil? ? RANGE_PRICE[price - 1] : ''
  end

  def no_of_units
    self.number_of_units.present? ? self.number_of_units : self.units.count
  end

  #### UNITS
  # creating unit from contribute
  def created_unit session, building_data
    unit_attributes = building_data['units_attributes']['0']
    unit_id         = session[:form_data]['unit_id']
    
    unit_attributes['building_id'] = self.id
    unit        = Unit.find(unit_id) rescue nil
    unit_params = unit_attributes
    @unit  =  if unit.present?
                unit.update(unit_params)
              else
                Unit.create(unit_params)
              end
  end

  def fetch_or_create_unit params
    params           = params[:units_attributes]
    unit             = Unit.new(params.values[0])
    unit.building_id = self.id
    unit.save
    return unit
  end

  def unit_information?
    (no_of_units.present? && self.no_of_units > 0) || floors.present? || built_in.present?
  end

  #### END UNITS

  def update_rent active_listings = nil
    if active_listings.present?
      active_listings = active_listings.with_rent.order(rent: :asc)
      min_price = active_listings.first.rent rescue nil
      max_price = active_listings.last.rent  rescue nil
    else
      min_price, max_price = nil, nil
    end
    update_listings_price(min_price, max_price)
  end

  def self.transparentcity_buildings
    CacheService.new( records: where.not(building_street_address: nil),
                      key: 'transparentcity_buildings.all'
                    ).fetch
  end

  def self.neighborhood1
    self.select('neighborhood')
        .distinct.where.not(neighborhood: [nil, ''])
        .order(neighborhood: :asc).pluck(:neighborhood) 
  end

  private

  def update_listings_price min_price, max_price
    update_columns(min_listing_price: min_price, max_listing_price: max_price)
  end
  
  def update_neighborhood_counts
    popular_neighborhoods.each do |hood|
      if hood.buildings_count.to_i >= 0
        hood.buildings_count = Building.buildings_in_neighborhood(hood.name.downcase, hood.city).count
        hood.save
      end
    end
  end

  def popular_neighborhoods
    Neighborhood.where(name: [neighborhood, neighborhoods_parent, neighborhood3])
  end

  def address
    [building_street_address, city, state]
  end

end
