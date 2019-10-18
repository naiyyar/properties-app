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

class Building < ApplicationRecord
  include PgSearch
  include Imageable
  include SaveNeighborhood

  #Search and filtering methods
  extend BuildingSearch
  extend BuildingFilters
  extend BuildingSorting
  extend PopularSearches
  extend ImportBuildingReviews

  acts_as_voteable
  resourcify
  DIMENSIONS = ['cleanliness','noise','safe','health','responsiveness','management']
  ratyrate_rateable 'building','cleanliness','noise','safe','health','responsiveness','management'

  validates :building_street_address, presence: true
  validates_uniqueness_of :building_street_address, scope: [:zipcode], on: :create

  #From some buildings when submitting reviews getting
  #Error: undefined method `address=' for #<Building
  attr_accessor :address

  belongs_to :user
  has_many :reviews, as: :reviewable
  has_many :favorites, as: :favorable, dependent: :destroy
  has_many :units, :dependent => :destroy
  has_one :featured_comp, :foreign_key => :building_id, :dependent => :destroy
  has_many :featured_comp_buildings
  has_many :featured_comps, through: :featured_comp_buildings, :dependent => :destroy
  has_one :featured_building, :dependent => :destroy
  belongs_to :management_company, touch: true
  has_many :contacts, :dependent => :destroy
  has_many :listings, :foreign_key => :building_id, :dependent => :destroy
  
  accepts_nested_attributes_for :units, :allow_destroy => true

  #default_scope { order('listings_count DESC, building_name ASC, building_street_address ASC') }
  scope :updated_recently, -> { order('listings_count DESC, building_name ASC, building_street_address ASC') }
  scope :order_by_min_rent, -> { order('min_listing_price ASC, listings_count DESC') }
  scope :order_by_max_rent, -> { order('max_listing_price DESC NULLS LAST, listings_count DESC') }
  scope :order_by_min_price, -> { order({price: :asc, listings_count: :desc, building_name: :asc, building_street_address: :asc}) }

  geocoded_by :street_address
  after_validation :geocode

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  #pgsearch
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

  #
  scope :saved_favourites, -> (user) do
    joins(:favorites).where('buildings.id = favorites.favorable_id AND favorites.favoriter_id = ?', user.id )
  end

  scope :active_featured_buildings, -> (buildings) do 
    buildings.joins(:featured_building).where('buildings.id = featured_buildings.building_id AND active is true')
  end

  scope :building_photos, -> (buildings) do 
    buildings.joins(:uploads).where('buildings.id = uploads.imageable_id AND imageable_type = ?', 'Building')
  end

  scope :with_active_listing, -> {where('listings_count > ?', 0)}

  #amenities scopes
  AMENITIES = [:doorman, :courtyard, :laundry_facility, :parking, :elevator, :roof_deck, :swimming_pool,
                :management_company_run, :management_company_run, :gym, :live_in_super,:pets_allowed_cats,
                :pets_allowed_dogs, :walk_up,:childrens_playroom,:no_fee, :garage]
  
  AMENITIES.each do |item|
    unless item == :elevator
      scope item,  -> { where(item => true) }
    else
      scope item, -> { where.not(item => nil) }
    end
  end

  #bedrooms types
  scope :studio, -> { where(studio: 0) }
  scope :one_bed, -> { where(one_bed: 1) }
  scope :two_bed, -> { where(two_bed: 2) }
  scope :three_bed, -> { where(three_bed: 3) }
  scope :four_bed, -> { where(four_plus_bed: 4) }

  #Listings bedrooms types
  scope :with_listings_bed, -> (beds) { where('listings.bed in (?)', beds) }

  #callbacks
  after_create :update_neighborhood_counts
  after_update :update_neighborhood_counts, :if => Proc.new{ |obj| obj.continue_call_back? }
  after_destroy :update_neighborhood_counts

  #Methods

  def continue_call_back?
    !(avg_rating_changed? && recommended_percent_changed? && min_listing_price_changed? && max_listing_price_changed?)
  end

  def self.buildings_json_hash(searched_buildings)
    unless searched_buildings.class == Array
      searched_buildings.select(:id, 
                        :building_name, 
                        :building_street_address, 
                        :latitude, 
                        :longitude, 
                        :zipcode, 
                        :city, 
                        :min_listing_price,
                        :max_listing_price,
                        :listings_count,
                        :state, :price).as_json(:methods => [:featured])
    else
      searched_buildings.as_json(:methods => [:featured])
    end
  end

  def featured
    featured?
  end

  def active_comps
    featured_comps.active
  end

  def self.city_count city, sub_boroughs = nil
    if sub_boroughs.present?
      Rails.cache.fetch([self, city, 'sub_boroughs']) { where('city = ? OR neighborhood in (?)', city, sub_boroughs).count }
    else
      Rails.cache.fetch([self, city]) { where(city: city).count }
    end
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
      if bed == 0
        beds << 'Studio'
      else
        beds << bed
      end
    end
    beds
  end
  
  RANGE_PRICE = ['Studio', '$', '$$', '$$$', '$$$$']
  def range_price
    prices = []
    bedroom_ranges.map{|range| prices << RANGE_PRICE[range.to_i]}
    prices.join(',')
  end

  def amenities
    amenities = []
    ApplicationController.helpers.building_amenities.each_pair do |k, v|
      if self[k].present?
        if v == 'Elevator'
         amenities << "#{v}(#{elevator})"
        else
          amenities << v
        end
      end
    end
    amenities.join(',')
  end

  def rent_median_prices(rent_medians)
    rent_medians.where(range: price, bed_type: bedroom_ranges).order(price: :asc)
  end

  def saved_amount(rent_medians, broker_percent)
    median_prices = rent_median_prices(rent_medians).pluck(:price)
    median_prices.map {|price| (((price*12)*broker_percent)/100).to_i}.sort
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

  def building_reviews
    reviews.includes(:user, :uploads, :reviewable).order(created_at: :desc)
  end

  def image_uploads
    #including buildings
    uploads.where.not(image_file_name: nil).includes(:imageable)
  end

  def chached_image_uploads
    Rails.cache.fetch([self, 'image_uploads']) { image_uploads.to_a }
  end

  def doc_uploads
    uploads.where('document_file_name is not null').to_a
  end

  def featured?
    self.featured_building.present? and featured_building.active
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

  def coordinates
    [latitude, longitude].compact.join(', ')
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

  def neighborhood_search_string
    "#{neighbohoods}, #{city}, NY"
  end

  def no_of_units
    self.number_of_units.present? ? self.number_of_units : self.units.count
  end

  def fetch_or_create_unit params
    params = params[:units_attributes]
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

  def first_neighborhood
    neighborhood.present? ? neighborhood : neighborhoods_parent
  end

  def property_neighborhods
   "#{first_neighborhood} - #{parent_neighbors}"
  end

  def parent_neighbors
    if neighborhood.present? and neighborhoods_parent.present? and neighborhood3.present? 
      (neighborhoods_parent == neighborhood) ? neighborhood3 : neighborhoods_parent
    else
      neighborhood3.present? ? neighborhood3 : neighborhoods_parent
    end
  end

  #finding similar properties may be on the basis amenities
  def similar_properties
    buildings = Building.where('id <> ?', self.id)
  end

  def formatted_neighborhood type=''
    if type == 'parent'
      @neighborhood = self.neighborhoods_parent
    else
      @neighborhood = self.neighborhood
    end

    return "#{@neighborhood.downcase.gsub(' ', '-')}-#{formatted_city}"
  end

  def formatted_city
    self.city.downcase.gsub(' ', '')
  end

  def self.number_of_buildings neighbohood
    where("neighborhood @@ :q OR neighborhoods_parent @@ :q OR neighborhood3 @@ :q" , q: neighbohood).count
  end

  def popular_neighborhoods
    Neighborhood.where('name = ? OR name = ? OR name = ?', self.neighborhood, self.neighborhoods_parent, self.neighborhood3)
  end

  def prices
    case price
    when 1
      '$'
    when 2
      '$$'
    when 3
      '$$$'
    when 4
      '$$$$'
    else
      ''
    end
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
    (no_of_units.present? and self.no_of_units > 0) || floors.present? || built_in.present?
  end

  def favorite_by?(favoriter)
    favorites.find_by(favoriter_id: favoriter.id, favoriter_type: favoriter.class.base_class.name).present?
  end

  def has_active_email?
    email.present? and active_email
  end

  def active_web_url?
    web_url.present? and active_web
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
