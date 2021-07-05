class Building < ApplicationRecord
  acts_as_voteable
  resourcify

  include ImageableConcern
  include FavoritableConcern
  include RateableConcern
  include PgSearch::Model
  include BuildingReviews
  include Voteable
  include BedRanges

  # constants
  RANGE_PRICE = ['$', '$$', '$$$', '$$$$'].freeze
  COLIVING_NUM = 9
  PENTHOUSES_MIN_PRICE = 8000
  BEDROOMS = [
               ['0',  'Studio'  ],
               ['1',  '1 Bed'   ],
               ['2',  '2 Bed'   ],
               ['3',  '3 Bed'   ],
               ['4',  '4+ Bed'  ],
               ['9',  'CoLiving']
            ].freeze
  
  ratyrate_rateable 'building','cleanliness','noise','safe','health','responsiveness','management'

  validates :building_street_address, presence: true
  validates_uniqueness_of :building_street_address, scope: [:zipcode], on: :create

  attr_accessor :address, :min_price, :max_price, :act_listings

  belongs_to :user, optional: true
  belongs_to :management_company, touch: true, optional: true
  has_many :reviews, as: :reviewable
  has_many :featured_buildings, dependent: :destroy

  # Scopes
  scope :order_by_id_pos,    -> (ids) { where(id: ids.uniq).order("array_position(ARRAY[#{ids.join(',')}], buildings.id)") }
  scope :updated_recently,   -> { order({listings_count: :desc, building_name: :asc, building_street_address: :asc}) }
  scope :order_by_max_price, -> { order('price DESC NULLS LAST, listings_count DESC, building_name ASC, building_street_address ASC') }
  scope :with_amenities, -> (amenities) { where("amenities @> ARRAY[?]::varchar[]", amenities) }

  # pgsearch
  pg_search_scope :search, against: [:building_name, :building_street_address],
     :using => { :tsearch => { prefix: true } }

  filterrific(
   default_filter_params: { },
   available_filters: [
     :search_query
    ]
  )

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

  def featured?
    featured_buildings_count.to_i > 0
  end

  def property_type
    self.class.name
  end

  def cached_listings
    CacheService.new( records: self.listings,
                      key: "active_listings_#{self.id}"
                    ).fetch
  end

  def get_listings filter_params, type='active', load_more_params={}
    Filter::Listings.new(self, 
                         load_more_params, 
                         type, 
                         filter_params).fetch_listings
  end

  def nearby_neighborhood
    return neighborhood3 if neighborhood3.present?
    neighborhoods_parent.present? ? neighborhoods_parent : neighborhood
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

  def formatted_city
    self.city.downcase.gsub(' ', '')
  end

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

  def self.app_buildings
    CacheService.new( records: where.not(building_street_address: nil),
                      key: 'app_buildings.all'
                    ).fetch
  end

  def self.neighborhood1
    self.select('neighborhood')
        .distinct.where.not(neighborhood: [nil, ''])
        .order(neighborhood: :asc).pluck(:neighborhood) 
  end

  private

  def address
    [building_street_address, city, state]
  end

end
