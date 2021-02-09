class FeaturedListing < ApplicationRecord
	include PgSearch::Model
  include Billable
  include ImageableConcern
  include Tourable

  extend RenewPlan

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
                  against: [:id], 
                  associated_against: {
                    building: [:building_name, :building_street_address]
                  }

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
  geocoded_by :full_address
  after_validation :geocode

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

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
end
