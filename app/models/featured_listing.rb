class FeaturedListing < ApplicationRecord
	include PgSearch::Model
  include Billable
  include ImageableConcern
  include Tourable

  extend RenewPlan
  extend SplitViewDisplayCard

  # constant
  FEATURING_WEEKS = 'two'
  
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
                  against: [:first_name, :neighborhood, :address]

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

  reverse_geocoded_by :latitude, :longitude, on: :update
  after_validation :reverse_geocode, on: :update

  # delegates
  delegate :email, to: :user, prefix: true

  # methods
  
  def full_address
  	[address, city, state, zipcode].join(', ')
  end

  def street_address
    address
  end

  def owner_full_name
    "#{first_name} #{last_name}"
  end

  def name_with_last_initial
    "#{first_name} #{last_name.first}"
  end

  def property_type
    self.class.name
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

end
