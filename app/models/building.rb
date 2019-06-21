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
#  recommended_percent     :float

class Building < ActiveRecord::Base
  include PgSearch
  include Imageable
  acts_as_voteable
  resourcify
  DIMENSIONS = ['cleanliness','noise','safe','health','responsiveness','management']
  ratyrate_rateable 'building','cleanliness','noise','safe','health','responsiveness','management'

  validates :building_street_address, presence: true
  validates_uniqueness_of :building_street_address, scope: [:zipcode]

  #form some buildings when submitting reviews getting
  #Error: undefined method `address=' for #<Building
  attr_accessor :address, :uploaded_images

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
  
  accepts_nested_attributes_for :units, :allow_destroy => true

  default_scope { order('building_name ASC, building_street_address ASC') }

  geocoded_by :street_address
  after_validation :geocode

  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode

  #callbacks
  after_create :save_neighborhood, :update_neighborhood_counts
  after_update :update_neighborhood, :update_neighborhood_counts, :if => Proc.new{ |obj| obj.continue_call_back? }
  after_destroy :update_neighborhood_counts

  #multisearchable
  # PgSearch.multisearch_options = {
  #   :using => [:tsearch, :trigram, :dmetaphone],
  #   :ignoring => :accents
  # }
  # multisearchable :against => [:neighborhood, :building_name]

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

  filterrific(
   default_filter_params: { },
   available_filters: [
     :search_query
    ]
  )

  #amenities scopes
  scope :doorman, -> { where(doorman: true) }
  scope :courtyard, -> { where(courtyard: true) }
  scope :laundry_facility, -> { where(laundry_facility: true) }
  scope :parking, -> { where(parking: true) }
  scope :elevator, -> { where.not(elevator: nil) }
  scope :roof_deck, -> { where(roof_deck: true) }
  scope :swimming_pool, -> { where(swimming_pool: true) }
  scope :mgmt_company_run, -> { where(management_company_run: true) }
  scope :garage, -> { where('garage is true') }
  scope :gym, -> { where('gym is true') }
  scope :live_in_super, -> { where('live_in_super is true') }
  scope :pets_allowed_cats, -> { where('pets_allowed_cats is true') }
  scope :pets_allowed_dogs, -> { where('pets_allowed_dogs is true') }
  scope :walk_up, -> { where(walk_up: true) }
  scope :childrens_playroom, -> { where(childrens_playroom: true) }
  scope :no_fee, -> { where(no_fee: true) }

  #bedrooms types
  scope :studio, -> { where(studio: 0) }
  scope :one_bed, -> { where(one_bed: 1) }
  scope :two_bed, -> { where(two_bed: 2) }
  scope :three_bed, -> { where(three_bed: 3) }
  scope :four_bed, -> { where(four_plus_bed: 4) }


  #Service module
  #Search and filtering methods
  extend BuildingSearch

  #Methods

  ### 
  #Used in buildings controller index action filterrific
  # def self.options_for_sorted_by
  #   [
  #     ['Name (a-z)', 'building_name_asc'],
  #     ['Name (z-a)', 'building_name_desc'],
  #     ['Creating date (newest first)', 'created_at_desc'],
  #     ['Creating date (oldest first)', 'created_at_asc']
  #   ]
  # end

  def self.buildings_json_hash(top_two_featured_buildings=nil, buildings)
    if top_two_featured_buildings.present?
      if buildings.kind_of? Array
        buildings = buildings - top_two_featured_buildings
      else
        buildings = buildings.where.not(id: top_two_featured_buildings.map(&:id))
      end
      buildings = top_two_featured_buildings + buildings
    end
    unless buildings.class == Array
      buildings.select(:id, 
                        :building_name, 
                        :building_street_address, 
                        :latitude, 
                        :longitude, 
                        :zipcode, 
                        :city, 
                        :state, :price).as_json(:methods => [:featured])
    else
      buildings.as_json(:methods => [:featured])
    end
  end

  def featured
    featured?
  end

  def self.city_count city, sub_boroughs = nil
    if sub_boroughs.present?
      buildings = where('city = ? OR neighborhood in (?)', city, sub_boroughs)
    else
      buildings = where(city: city)
    end
    buildings.count
  end

  def suggested_percent
    Vote.recommended_percent(self)
  end

  def saved_amount(broker_percent)
    median_arr = []
    bedroom_ranges.each do |bed_range|
      prices = RentMedian.where(bed_type: bed_range, range: price)
      if prices.present?
        median = prices.first
        median_arr << (((median.price * 12)*broker_percent)/100).to_i
      end
    end
    median_arr.sort
  end

  def min_save_amount broker_percent
    saved_amount(broker_percent)[0]
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

  def cached_reviews_count
    Rails.cache.fetch([self, 'reviews_count']) { reviews.size }
  end

  def image_uploads
    uploads.where.not(image_file_name: nil).where("imageable_id = ? or imageable_id in (?)", id, units.pluck(:id)).includes(:imageable)
  end

  def chached_image_uploads
    Rails.cache.fetch([self, 'image_uploads']) { image_uploads.to_a }
  end

  def chached_doc_uploads
    Rails.cache.fetch([self, 'doc_uploads']) { uploads.where('document_file_name is not null').to_a }
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

  def self.import_reviews file
    user = User.find_by_email('reviews@transparentcity.co')
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose ]
      if row['building_address'].present?
        @buildings = Building.where(building_street_address: row['building_address'], zipcode: row['zipcode'])
        unless @buildings.present?
          @building = Building.create({ building_street_address: row['building_address'], 
                                      city: row['city'], 
                                      state: 'NY', 
                                      zipcode: row['zipcode']
                                    })
        else
          @building = @buildings.first
        end
        
        if @building.present? and @building.id.present?
          rev = Review.new
          rev.attributes = row.to_hash.slice(*row.to_hash.keys[5..8]) #excluding building specific attributes
          
          rev[:reviewable_id] = @building.id
          rev[:reviewable_type] = 'Building'
          rev[:anonymous] = true
          rev[:created_at] = DateTime.parse(row['created_at'])
          rev[:updated_at] = DateTime.parse(row['created_at'])
          rev[:user_id] = user.id
          rev[:tos_agreement] = true
          rev[:scraped] = true
          rev.save!

          #row['rating'] => score
          if rev.present? and rev.id.present?
            user.create_rating(row['rating'], @building, rev.id, 'building')
            if row['vote'].present? and row['vote'] == 'yes'.downcase
              @vote = user.vote_for(@building)
            else
              @vote = user.vote_against(@building)
            end
            
            if @vote.present?
              @vote.review_id = rev.id
              @vote.save
            end
          end
        end
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
     when '.csv' then Roo::CSV.new(file.path)
     when '.xls' then Roo::Excel.new(file.path)
     when '.xlsx' then Roo::Excelx.new(file.path)
     else raise "Unknown file type: #{file.original_filename}"
    end
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
    else
      '$$$$'
    end
  end

  def bedroom_ranges
    Building.where(id: self.id).select(:studio, :one_bed, :two_bed, :three_bed, :four_plus_bed).to_a.first.attributes.values.compact
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

  def continue_call_back?
    !self.avg_rating_changed? && !recommended_percent_changed?
  end

  private

  #child neighbohoods
  def predifined_neighborhoods
    arr = []
    File.open("#{Rails.root}/public/neighborhoods.txt", "r").each_line do |line|
      arr << line.split(/\n/)
    end
    nyc_neighborhoods = arr.flatten.uniq
    nyc_neighborhoods << ApplicationController.helpers.queens_borough
    nyc_neighborhoods << ApplicationController.helpers.bronx_borough
    return  nyc_neighborhoods.flatten.sort
  end

  def just_parent_neighborhoods
    ['Harlem']
  end

  #Parent neighbohoods
  def parent_neighborhoods
    [ 'Midtown East','Midtown North',
      'Midtown South','Midtown West','Upper West Side',
      'Upper East Side','Lower East Side',
      'Greenwich Village','Flatbush - Ditmas Park'
    ]
  end

  def grandparent_neighborhoods
    ['Lower Manhattan', 'Upper Manhattan', 'Midtown']
  end

  #saving neighbohoods
  def neighborhoods
    search = Geocoder.search([latitude, longitude])
    if search.present? and first_neighborhood.blank?
      neighborhood1 = neighborhood2 = neighborhood3 = ''
      #search for child neighborhoods
      search[0..7].each_with_index do |geo_result, index|
        #finding neighborhood
        neighborhood = geo_result.address_components_of_type(:neighborhood)
        if neighborhood.present?
          neighborhood = neighborhood.first['long_name']
          sublocality = search[0].address_components_of_type(:sublocality)
          if sublocality.present?
            locality = sublocality.first['long_name']
          else
            locality = search[0].address_components_of_type(:locality).first['long_name']
          end
          #checking main neighborhood
          if ['Queens','Brooklyn','Bronx'].include?(locality) and self.city == neighborhood
            neighborhood1 = neighborhood
          elsif predifined_neighborhoods.include? neighborhood
            neighborhood1 = neighborhood if neighborhood1.blank?
          elsif just_parent_neighborhoods.include? neighborhood
            neighborhood2 = neighborhood
          elsif parent_neighborhoods.include? neighborhood #checking parent of main neighborhood
            neighborhood2 = neighborhood if neighborhood2.blank?
            neighborhood1 = neighborhood if neighborhood1.blank? and index >= 2
          elsif grandparent_neighborhoods.include? neighborhood #checking grandparent of main neighborhood
            neighborhood3 = neighborhood
            neighborhood2 = neighborhood if neighborhood2.blank? and neighborhood1.blank?
          else
            neighborhood1 = neighborhood if neighborhood1.blank?
            parent_neighborhood = 'East Village'
            neighborhood2 = parent_neighborhood
          end
          #discontinue once neighborhood is saved
          break
        end
      end #end search loop
    else
      neighborhood3 = self.neighborhood3
      if ['Alphabet City','Ukrainian Village'].include?(self.neighborhood)
        neighborhood1 = 'East Village'
        neighborhood2 = 'Lower Manhattan'
      elsif self.neighborhood == 'East Village'
        neighborhood1 = self.neighborhood
        neighborhood2 = 'Lower Manhattan'
      elsif ['Rose Hill'].include?(self.neighborhood)
        neighborhood1 = 'Kips Bay'
        neighborhood3 = 'Midtown'
      elsif ['Bloomingdale'].include?(self.neighborhood)
        neighborhood1 = 'Upper West Side'
      else
        neighborhood1 = self.neighborhood
        neighborhood2 = parent_neighborhood
      end
    end #end search if

    return neighborhood1, neighborhood2, neighborhood3
  end

  def parent_neighborhood
    if self.neighborhoods_parent.present?
      return self.neighborhoods_parent
    else
      buildings = Building.where('neighborhoods_parent is not null and neighborhood = ?', self.neighborhood)
      return buildings.present? ? buildings.first.neighborhoods_parent : nil
    end
  end

  def save_neighborhood
    if neighborhoods.present?
      self.neighborhood = neighborhoods[0]
      self.neighborhoods_parent = neighborhoods[1]
      self.neighborhood3 = neighborhoods[2]
      self.save
    end
  end

  def update_neighborhood
    if neighborhoods.present?
      self.update_columns(neighborhood: neighborhoods[0], neighborhoods_parent: neighborhoods[1], neighborhood3: neighborhoods[2])
    end
  end

  def update_neighborhood_counts
    popular_neighborhoods.each do |hood|
      if hood.buildings_count.to_i >= 0
        hood.buildings_count = Building.buildings_in_neighborhood(hood.name).count
        hood.save
      end
    end
  end

end
