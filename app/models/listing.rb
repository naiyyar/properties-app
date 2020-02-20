class Listing < ApplicationRecord
	include PgSearch
	
  # associations
  belongs_to :building
  counter_cache_with_conditions :building, :listings_count, active: true
  
  # constants
  BEDROOMS                = [['0', 'Studio'],['1','1 Bed'],['2', '2 Bed'],['3', '3 Bed'],['4', '4+ Bed']]
  EXPORT_SHEET_HEADER_ROW = ['Date active','Building address','Unit','Rent','Bed','Bath','Months Free',
                             'Owner Paid','Rent Stabilized','Zip Code','Building Price Range','Neighborhood',
                             'Parent Neighborhood', 'Neighborhood3', 'Property Manager','Number of Floors',
                             'Number of Units','Year Built','Active','Amenities']

  # validations
  validates_presence_of :building_address, :unit, :date_active
  validates :rent,        :numericality => true, :allow_nil => true
  validates :bed,         :numericality => true, :allow_nil => true
  validates :bath,        :numericality => true, :allow_nil => true
  validates :free_months, :numericality => true, :allow_nil => true
  validates_date :date_active,    :on => :create, :message => 'Formatting is off, must be yyyy/mm/dd'
  validates_date :date_available, :on => :create, allow_nil: true, allow_blank: true, :message => 'Formatting is off, must be yyyy/mm/dd'
  

  # scopes
	scope :active,          -> { where(active: true) }
	scope :inactive,        -> { where(active: false) }
  scope :months_free,     -> { where('free_months > ?', 0) }
  scope :owner_paid,      -> { where('owner_paid is not null') }
  scope :rent_stabilize,  -> { where('rent_stabilize = ?', 'true') }
  scope :with_prices,     -> (min, max) { where('rent >= ? AND rent <= ?', min.to_i, max.to_i) }
  scope :with_beds,       -> (beds) { where('bed in (?)', beds) }

  pg_search_scope :search_query, 
  								against: [:building_address, :management_company],
                  :using => {  :tsearch => { prefix: true }, 
                               :trigram=> { :threshold => 0.2 } 
                            },
                  associated_against: { building: [:building_name] }

  scope :default_listing_order,     -> { reorder(date_active: :desc, management_company: :asc, building_address: :asc, unit: :asc) }
  scope :order_by_date_active_desc, -> { reorder(date_active: :desc, rent: :asc) }
  scope :order_by_rent_asc,         -> { reorder(rent: :asc) }

	filterrific(
    default_filter_params: { default_listing_order: :default_listing_order },
    available_filters: [:default_listing_order, :search_query]
  )

  # callbacks
  after_save   :create_unit,  unless: :unit_exist?
  after_update :create_unit,  unless: :unit_exist?

  # delegates
  delegate :management_company, to: :building

  def self.header_style style
    Listing::EXPORT_SHEET_HEADER_ROW.map{|item| style}
  end

  def management_company_name
    management_company.try(:name)
  end

  def unit_exist?
  	building.units.where(name: unit).present?
  end

  def rentstabilize
    rent_stabilize.present? ? (rent_stabilize == 'true' ? 'Y' : 'N') : ''
  end

  def update_rent
    listings = building.listings.active.order(rent: :asc)
    if listings.present?
      building.update(min_listing_price: listings.first.rent)
      building.update(max_listing_price: listings.last.rent)
    else
      building.update(min_listing_price: nil)
      building.update(max_listing_price: nil)
    end
  end
  
  private
  def create_unit
  	Unit.create({ name: unit,
  								building_id: building_id,
  								number_of_bedrooms: bed,
									number_of_bathrooms: bath,
									monthly_rent: rent
  							})
  end

end
