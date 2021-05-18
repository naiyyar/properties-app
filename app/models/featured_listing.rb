class FeaturedListing < ApplicationRecord
	include PgSearch::Model
  include Billable
  include ImageableConcern
  include Tourable

  extend RenewPlan
  extend SplitViewFeaturedCard

  # constant
  FEATURING_WEEKS = 'two'
  FEATURING_DAYS = 14
  AMOUNT = 14
  
  APARTMENT_TYPE = [
    'Co-op',
    'Condo',
    'Condop',
    'Townhouse/House',
    'Rental Building',
    'Other'
  ].freeze

  # validations
  FIELDS_TO_VALIDATES = [ :first_name,
                          :last_name,
                          :email,
                          :neighborhood,
                          :address,
                          :city,
                          :zipcode,
                          :bed,
                          :bath
                        ]
  
  belongs_to :user

  # scopes
  scope :active,      -> { where(active: true) }
  scope :inactive,    -> { where(active: false) }
  scope :by_manager,  -> { where(featured_by: 'manager') }

  pg_search_scope :search_query, 
                  against: [:unit, :neighborhood, :address]

  filterrific(
   default_filter_params: { },
   available_filters: [
     :search_query
    ]
  )
  
  FIELDS_TO_VALIDATES.each do |field|
  	validates field, presence: true, on: :update
  end

  validates :apartment_type, 
            presence: true, 
            inclusion: { in: APARTMENT_TYPE }, on: :update
  validates :rent, 
            presence: true, 
            numericality: { greater_than_or_equal_to: 0 }, on: :update
  
  #
  geocoded_by :full_address, on: :update
  after_validation :geocode, on: :update

  # delegates
  delegate :email, to: :user, prefix: true

  # methods
  
  def full_address
  	[address, city, state, zipcode].join(', ')
  end

  def city_state_zip
    [city, state, zipcode].join(', ')
  end

  alias_method :full_street_address, :full_address

  def street_address
    address
  end

  alias_method :property_name_or_address, :street_address

  def address_with_unit
    "#{address} #{unit}"
  end

  def full_address_with_unit
    "#{full_address} #{unit}"
  end

  def owner_full_name
    "#{first_name} #{last_name}"
  end

  def name_with_last_initial
    "#{first_name} #{last_name.first}."
  end

  def property_type
    self.class.name
  end

  def name
    ''
  end

  def featured?
    self.active && !expired?
  end

  def featured
    featured?
  end

  def price
    @price ||= self.rent
  end

  def self.as_json_hash(listings)
    listings.select(*attrs_to_select).as_json(:methods => json_hash_methods)
  end

  def self.json_hash_methods
    [:featured?, :featured, :property_type, :price, :full_address]
  end

  def self.attrs_to_select
    [
       :id, 
       :rent, 
       :address, 
       :latitude, 
       :longitude, 
       :zipcode, 
       :city, 
       :state, 
       :apartment_type,
       :active,
       :end_date,
       :start_date
    ]
  end

  def get_subway_lines
    CacheService.new(records: DistanceMatrixService.new(self).get_data, 
                     key: "subway_lines_#{self.id}"
                    ).fetch
  end

end
