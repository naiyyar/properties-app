class PastListing < ApplicationRecord
	include PgSearch::Model
  include Listable
  # associations
  belongs_to :building
  
  # constants
  LIMIT = 500

  # scopes
  scope :inactive,        -> { where(active: false) }
  scope :between,         -> (from, to) { where('date_active >= ? AND date_active <= ?', from, to) }
  scope :months_free,     -> { where('free_months > ?', 0) }
  scope :owner_paid,      -> { where.not(owner_paid: nil) }
  scope :rent_stabilize,  -> { where(rent_stabilize: true) }
  scope :with_prices,     -> (min, max) { where('rent >= ? AND rent <= ?', min.to_i, max.to_i) }
  scope :with_beds,       -> (beds) { where(bed: beds) }

  pg_search_scope :search_query, 
                  against: [:building_address, :management_company],
                  :using => {  :tsearch => { prefix: true }, 
                               :trigram=> { :threshold => 0.2 } 
                            },
                  associated_against: { building: [:building_name] }

  scope :default_listing_order,     -> { reorder(date_active: :desc, 
                                                 management_company: :asc, 
                                                 building_address: :asc, 
                                                 unit: :asc) }
  scope :order_by_date_active_desc, -> { reorder(date_active: :desc, rent: :asc, unit: :asc) }
  scope :order_by_rent_asc,         -> { reorder(rent: :asc) }

  filterrific(
    default_filter_params: { default_listing_order: :default_listing_order },
    available_filters: [:default_listing_order, :search_query]
  )

  # delegates
  delegate :management_company, to: :building

  def self.header_style style
    EXPORT_SHEET_HEADER_ROW.map{|item| style}
  end

end
