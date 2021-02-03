class FeaturedListing < ApplicationRecord
	include PgSearch::Model
  include Billable

  extend RenewPlan
  
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

  # constant
  
  FEATURED_IN_NEIGHBORHOODS = [
		'Lower Manhattan',
		'Midtown Manhattan',
		'Upper East Side',
		'Upper West Side',
		'Upper Manhattan',
		'Brooklyn',
		'Queens',
		'Bronx'
	].freeze
  
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
													:neighbrhood,
													:address,
													:city,
													:zipcode,
													:bed,
													:bath
												]
  FIELDS_TO_VALIDATES.each do |field|
  	validates field, presence: true
  end

  validates :apartment_type, 
            presence: true, 
            inclusion: { in: APARTMENT_TYPE }, on: :update
  validates :rent, 
            presence: true, 
            numericality: { greater_than_or_equal_to: 0 }, on: :update
  
  # delegates
  
  delegate :email, to: :user, prefix: true

  # methods
  
  def full_address
  	[address, city, state, zipcode].join(', ')
  end
end
