# == Schema Information
#
# Table name: buildings
#
#  id                      :integer          not null, primary key
#  building_name           :string
#  building_street_address :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  photo_file_name         :string
#  photo_content_type      :string
#  photo_file_size         :integer
#  photo_updated_at        :datetime
#  latitude                :float
#  longitude               :float
#  address2                :string
#  zipcode                 :string
#  webaddress              :string
#  city                    :string
#  phone                   :string
#  state                   :string
#  laundry_facility        :boolean
#  parking                 :boolean
#  doorman                 :boolean
#  description             :text
#  elevator                :integer
#  garage                  :boolean          default(FALSE)
#  gym                     :boolean          default(FALSE)
#  live_in_super           :boolean          default(FALSE)
#  pets_allowed_cats       :boolean          default(FALSE)
#  pets_allowed_dogs       :boolean          default(FALSE)
#  roof_deck               :boolean          default(FALSE)
#  swimming_pool           :boolean          default(FALSE)
#  walk_up                 :boolean          default(FALSE)
#  neighborhood            :string
#  neighborhoods_parent    :string
#  user_id                 :integer
#  floors                  :integer
#  built_in                :integer
#  number_of_units         :integer
#  courtyard               :boolean          default(FALSE)
#  management_company_run  :boolean          default(FALSE)
#  neighborhood3           :string
#  web_url                 :string
#  building_type           :string
#  childrens_playroom      :boolean          default(FALSE)
#  no_fee                  :boolean          default(FALSE)
#  reviews_count           :integer
#  management_company_id   :integer
#  studio                  :integer
#  one_bed                 :integer
#  two_bed                 :integer
#  three_bed               :integer
#  four_plus_bed           :integer
#  price                   :integer
#  active_web              :boolean
#  active_email            :boolean
#  online_application_link :boolean
#  show_application_link   :boolean

class Building < ApplicationRecord
  RANGE_PRICE = ['$', '$$', '$$$', '$$$$']
  BEDROOMS    = [['0', 'Studio'],['1','1 Bed'],['2', '2 Bed'],['3', '3 Bed'],['4', '4+ Bed']]
  CITIES      = ['New York', 'Brooklyn', 'Bronx', 'Queens']
  
  include PgSearch
  include Imageable
  include SaveNeighborhood
  include BuildingReviews

  # Search and filtering methods
  extend Search::BuildingSearch
  extend Search::BuildingFilters
  extend Search::BuildingSorting
  extend Search::PopularSearches
  extend Search::RedoSearch

  acts_as_voteable
  resourcify
 
  DIMENSIONS = ['cleanliness','noise','safe','health','responsiveness','management']
  ratyrate_rateable 'building','cleanliness','noise','safe','health','responsiveness','management'

  validates :building_street_address, presence: true
  validates_uniqueness_of :building_street_address, scope: [:zipcode], on: :create

  # From some buildings when submitting reviews getting
  # Error: undefined method `address=' for #<Building
  attr_accessor :address

  belongs_to :user
  belongs_to :management_company, touch: true
  has_many :reviews,                as:         :reviewable
  has_many :favorites,              as:         :favorable,     dependent: :destroy
  has_one  :featured_comp,          foreign_key: :building_id,  dependent: :destroy
  has_many :featured_comps,         through: :featured_comp_buildings, dependent: :destroy
  has_many :featured_buildings,     dependent: :destroy
  has_many :contacts,               dependent: :destroy
  has_many :listings,               foreign_key: :building_id, dependent: :destroy
  has_many :past_listings,          foreign_key: :building_id, dependent: :destroy
  has_many :featured_comp_buildings
  has_many :units,                  dependent: :destroy
  accepts_nested_attributes_for :units, :allow_destroy => true

  # Scopes
  scope :updated_recently,   -> { order('listings_count DESC, building_name ASC, building_street_address ASC') }
  scope :order_by_min_rent,  -> { order('min_listing_price ASC, listings_count DESC') }
  scope :order_by_max_rent,  -> { order('max_listing_price DESC NULLS LAST, listings_count DESC') }
  scope :order_by_min_price, -> { order({price: :asc, listings_count: :desc, building_name: :asc, building_street_address: :asc}) }

  scope :saved_favourites, -> (user) do
    joins(:favorites).where('buildings.id = favorites.favorable_id AND favorites.favoriter_id = ?', user.id )
  end
  scope :building_photos, -> (buildings) do 
    buildings.joins(:uploads).where('buildings.id = uploads.imageable_id AND imageable_type = ?', 'Building')
  end

  scope :with_active_listing,   -> { where('listings_count > ?', 0) }
  scope :with_listings_bed, -> (beds) { where('listings.bed in (?)', beds) }
  scope :with_active_web,       -> { where('active_web is true and web_url is not null') }
  scope :with_active_email,     -> { where('active_email is true and email is not null') }
  scope :with_application_link, -> { where('show_application_link is true and online_application_link is not null') }
  scope :with_pets,             -> { where('pets_allowed_cats is true OR pets_allowed_dogs is true') }
  
  scope :studio,    -> { where(studio: 0) }
  scope :one_bed,   -> { where(one_bed: 1) }
  scope :two_bed,   -> { where(two_bed: 2) }
  scope :three_bed, -> { where(three_bed: 3) }
  scope :four_bed,  -> { where(four_plus_bed: 4) }
  # amenities scopes
  AMENITIES = [:doorman, :courtyard, :laundry_facility, :parking, :elevator, :roof_deck, :swimming_pool,
                :management_company_run, :gym, :live_in_super,:pets_allowed_cats,
                :pets_allowed_dogs, :walk_up,:childrens_playroom,:no_fee, :garage]
  
  AMENITIES.each do |item|
    unless item == :elevator
      scope item,  -> { where(item => true) }
    else
      scope item, -> { where.not(item => nil) }
    end
  end

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
  
  # Methods

  def continue_call_back?
    ( avg_rating_changed?          && 
      recommended_percent_changed? && 
      min_listing_price_changed?   && 
      max_listing_price_changed?)
  end

  # creating unit from contribute
  def created_unit session, building_data
    unit_attributes = building_data['units_attributes']['0']
    unit_id         = session[:form_data]['unit_id']
    
    unit_attributes['building_id'] = self.id
    unit            = Unit.find(unit_id) rescue nil
    unit_params     = unit_attributes
    @unit  =  if unit.present?
                unit.update(unit_params)
              else
                Unit.create(unit_params)
              end
  end

  def featured
    featured?
  end

  def active_comps
    featured_comps.active
  end

  def active_listings filter_params, type='active'
    Filter::Listings.new(self, type, filter_params).active_listings
  end

  def all_three_cta? listings_count
    active_web_url? && has_active_email? && listings_count > 0
  end

  def availability_and_contacts_cta?
    active_web_url? && has_active_email?
  end

  def show_apply_link?
    online_application_link.present? && show_application_link 
  end

  def show_contact_leasing?
    email.present? && active_email
  end

  def all_3_contact_link?
    show_apply_link? && show_contact_leasing? && active_web_url?
  end

  def apply_and_leasing?
    show_apply_link? && show_contact_leasing?
  end

  def apply_and_availability?
    show_apply_link? && active_web_url?
  end

  def leasing_and_availability?
    show_contact_leasing? && active_web_url?
  end

  def leasing?
    show_contact_leasing? && !(apply_and_availability?)
  end

  def availability?
    active_web_url? && !(apply_and_leasing?)
  end

  def apply?
    show_apply_link? && !(leasing_and_availability?)
  end

  def suggested_percent
    Vote.recommended_percent(self)
  end

  def bedroom_ranges
    [studio, one_bed, two_bed, three_bed, four_plus_bed].compact
  end

  def show_bed_ranges
    beds = []
    bedroom_ranges.map do |bed|
      beds << (bed == 0 ? 'Studio' : bed)
    end
    beds
  end

  def price_ranges
    ranges = {}
    prices = Price.where(range: price)
    bedroom_ranges.each{|bed_range| ranges[bed_range] = prices.find_by(bed_type: bed_range)}
    return ranges
  end

  def amenities
    amenities = []
    BuildingAmenities.all_amenities.each_pair do |k, v|
      if self[k].present?
        amenities << (v == 'Elevator' ? "#{v}(#{elevator})" : v)
      end
    end
    amenities.join(',')
  end

  def rent_median_prices(rent_medians)
    rent_medians.where(range: price, bed_type: bedroom_ranges).order(price: :asc)
  end

  def saved_amount(rent_medians, broker_percent)
    median_prices = rent_median_prices(rent_medians).pluck(:price)
    median_prices.map{|price| (((price*12)*broker_percent)/100).to_i}.sort
  end

  def min_save_amount rent_medians, broker_percent
    saved_amount(rent_medians, broker_percent)[0]
  end

  def to_param
    slug
  end

  def slug
    slug = building_name.present? ? "#{id} #{building_name}" : "#{id} #{building_street_address}"
    slug.parameterize
  end

  def image_uploads
    uploads.where.not(image_file_name: nil).includes(:imageable)
  end

  def chached_image_uploads
    Rails.cache.fetch([self, 'image_uploads']) { image_uploads.to_a }
  end

  def doc_uploads
    uploads.where.not(document_file_name: nil).to_a
  end

  def featured?
    featured_buildings.active.present?
  end

  def neighbohoods
    first_neighborhood.present? ? first_neighborhood : neighborhood3
  end

  def neighborhood_name
    neighbohoods
  end

  def name
    self.building_name
  end

  def rating_cache?
    rating_cache.where(dimension: DIMENSIONS).present?
  end

  def rating_cache
    RatingCache.where(cacheable_id: self.id, cacheable_type: 'Building') 
  end

  def upvotes_count
    votes.where(vote: true).count
  end

  def downvotes_count
    votes.where(vote: false).count
  end

  def total_votes
    votes.count
  end

  def zipcode=(val)
    write_attribute(:zipcode, val.to_s.gsub(/\s+/,'')) if val.present?
  end

  def street_address
    [building_street_address, city, state].compact.join(', ')
  end

  def full_street_address
    [building_street_address, city, state, zipcode].compact.join(', ')
  end

  def building_name_or_address
    building_name.present? ? building_name : building_street_address
  end

  def no_of_units
    self.number_of_units.present? ? self.number_of_units : self.units.count
  end

  def fetch_or_create_unit params
    params           = params[:units_attributes]
    unit             = Unit.new(params.values[0])
    unit.building_id = self.id
    unit.save
    return unit
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

  def formatted_city
    self.city.downcase.gsub(' ', '')
  end

  def self.number_of_buildings neighbohood
    where("neighborhood @@ :q 
           OR neighborhoods_parent @@ :q 
           OR neighborhood3 @@ :q" , q: neighbohood).count
  end

  def popular_neighborhoods
    Neighborhood.where('name = ? OR 
                        name = ? OR 
                        name = ?', neighborhood, neighborhoods_parent, neighborhood3)
  end

  def prices
    !price.nil? ? RANGE_PRICE[price - 1] : ''
  end

  def bedroom_types?
    studio.present? || either_of_four?
  end
  
  def either_of_two?
    three_bed.present? || four_plus_bed.present?
  end
  
  def either_of_three?
    either_of_two? || two_bed.present?
  end
  
  def either_of_four?
    either_of_three? || one_bed.present?
  end

  def unit_information?
    (no_of_units.present? && self.no_of_units > 0) || floors.present? || built_in.present?
  end

  def favorite_by?(favoriter)
    favorites.find_by(favoriter_id:   favoriter.id, 
                      favoriter_type: favoriter.class.base_class.name).present?
  end

  def has_active_email?
    email.present? && active_email
  end

  def active_web_url?
    web_url.present? && active_web
  end

  def fav_color_class user_id = nil
    if user_id.present?
      favorite_by?(User.find(user_id)) ? 'filled-heart' : 'unfilled-heart'
    else
      'unfilled-heart'
    end 
  end

  private
  
  def update_neighborhood_counts
    popular_neighborhoods.each do |hood|
      if hood.buildings_count.to_i >= 0
        hood.buildings_count = Building.buildings_in_neighborhood(hood.name, hood.boroughs).count
        hood.save
      end
    end
  end

end
