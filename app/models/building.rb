class Building < ActiveRecord::Base

  include PgSearch
  include Imageable
  
  acts_as_voteable
  resourcify
  ratyrate_rateable 'building','cleanliness','noise','safe','health','responsiveness','management'

  validates :building_street_address, presence: true
  validates_uniqueness_of :building_street_address, scope: [:zipcode]

  belongs_to :user
  has_many :reviews, as: :reviewable
  has_many :units,  :dependent => :destroy
  
  accepts_nested_attributes_for :units, :allow_destroy => true

  default_scope { order('building_name ASC, building_street_address ASC') }

  geocoded_by :street_address
  after_validation :geocode

  #callbacks
  after_create :save_neighborhood
  after_update :update_neighborhood

  #multisearchable
  # PgSearch.multisearch_options = {
  #   :using => [:tsearch, :trigram, :dmetaphone],
  #   :ignoring => :accents
  # }
  # multisearchable :against => [:neighborhood, :building_name]

  #pgsearch
  pg_search_scope :search, against: [:building_name, :building_street_address],
     :using => { :tsearch => { prefix: true } }

  pg_search_scope :search_by_neighborhood, against: [:neighborhood],
     :using => {  :tsearch => { prefix: true }, 
                  :trigram=> { :threshold => 0.2 } 
                }
  pg_search_scope :search_by_pneighborhood, against: [:neighborhoods_parent],
     :using => {  :tsearch => { prefix: true }, 
                  :trigram=> { :threshold => 0.1 } 
                }

  pg_search_scope :text_search_by_building_name, against: [:building_name],
                  :using => { :tsearch=> { prefix: true }#, :trigram => {:threshold => 0.3}
                  }

  pg_search_scope :search_by_street_address, against: [:building_street_address],
    :using => {:tsearch=> { prefix: true }, :trigram=> {
                  :threshold => 0.2
                }}

  pg_search_scope :text_search_by_city, against: [:city],
    :using => {:tsearch=> { prefix: true }, :trigram=> {
                  :threshold => 0.2
                }}

  pg_search_scope :search_by_zipcode, against: [:zipcode],
    :using => {:tsearch=> { prefix: true }, :trigram=> {
                  :threshold => 0.5
                }}

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

  #Methods

  def to_param
    if building_name.present?
      "#{id} #{building_name}".parameterize
    else
      "#{id} #{building_street_address}".parameterize
    end
  end

  def neighbohoods
    first_neighborhood.present? ? first_neighborhood : neighborhood3
  end

  def image_uploads
    self.uploads.where('image_file_name is not null')
  end

  def name
    self.building_name
  end

  def self.sort_buildings(buildings, sort_params)
    # 0 => Default
    # 1 => Rating (high to low)
    # 2 => Rating (high to low)
    # 3 => Reviews (high to low)
    # 4 => A to Z
    # 5 => Z to A
    case sort_params
    when '1'
      buildings = sort_by_rating(buildings, '1')
    when '2'
      buildings = sort_by_rating(buildings, '2')
    when '3'
      buildings = buildings.reorder('reviews_count DESC')
    when '4'
      buildings = buildings.reorder('building_name ASC, building_street_address ASC')
    when '5'
      buildings = buildings.reorder('building_name DESC, building_street_address DESC')
    else
      buildings = buildings
    end
    buildings
  end

  def self.sort_by_rating buildings, sort_index
    if sort_index == '1'
      @ratings = RatingCache.where(cacheable_id: buildings.map(&:id)).order('avg DESC')
    else
      @ratings = RatingCache.where(cacheable_id: buildings.map(&:id)).order('avg ASC')
    end
    
    building_ids = @ratings.map(&:cacheable_id)
    rated_buildings = buildings.where(id: building_ids).sort_by{ |b| building_ids.index(b.id) if !b.id.nil? }
    non_rated_buildings = buildings.where.not(id: rated_buildings.map(&:id))
    
    buildings = rated_buildings+non_rated_buildings
    
    buildings
  end

  def self.filter_by_rates buildings, rating
    # 1 star - means  = 1
    # 2 star - means  1 <= 2
    # 3 star - means  2 <= 3
    # 4 star - means  3 <= 4
    # 5 star - means  4 <= 5 
    if rating.present?
      rates = RatingCache.where(cacheable_type: 'Building')
      if rating == '1'
        rates = rates.where('avg = ?', rating)
      else
        rates = rates.where('avg > ? AND avg <= ?', rating.to_i-1, rating)
        #rates = rates.where('avg > ?', rating.to_i-1)
      end
      buildings.where('id in (?)', rates.map(&:cacheable_id))
    else
      buildings
    end
  end

  # On Hold Right now
  def self.filter_by_beds buildings, beds
    # joins('LEFT JOIN events_tags ON (events.id = events_tags.event_id) LEFT JOIN tags ON (tags.id = events_tags.tag_id)')
    #   .where('tags.label' => tags).group('events.id').having("count(events.id) = #{tags.count}")
    if beds.present?
      units = Unit.where(number_of_bedrooms: beds)
      @buildings = buildings.where('id in (?)', units.map(&:building_id))
    else
      @buildings = buildings
    end
    @buildings
  end

  def self.filter_by_types buildings, type
    if type.present?
      @buildings = buildings.where(building_type: type)
    else
      @buildings = buildings
    end
    @buildings
  end

  def self.filter_by_amenities buildings, amenities
    @amenities = amenities
    if amenities.present?
      @buildings = buildings
      @buildings = @buildings.doorman if has_amenity?('doorman')
      @buildings = @buildings.courtyard if has_amenity?('courtyard')
      @buildings = @buildings.laundry_facility if has_amenity?('laundry_facility')
      @buildings = @buildings.parking if has_amenity?('parking')
      @buildings = @buildings.gym if has_amenity?('gym')
      @buildings = @buildings.garage if has_amenity?('garage')
      @buildings = @buildings.mgmt_company_run if has_amenity?('management_company_run')
      @buildings = @buildings.live_in_super if has_amenity?('live_in_super')
      @buildings = @buildings.roof_deck if has_amenity?('roof_deck')
      @buildings = @buildings.pets_allowed_cats if has_amenity?('pets_allowed_cats')
      @buildings = @buildings.pets_allowed_dogs if has_amenity?('pets_allowed_dogs')
      @buildings = @buildings.elevator if has_amenity?('elevator')
      @buildings = @buildings.swimming_pool if has_amenity?('swimming_pool')
      @buildings = @buildings.childrens_playroom if has_amenity?('childrens_playroom')
      @buildings = @buildings.walk_up if has_amenity?('walk_up')
      @buildings = @buildings.no_fee if has_amenity?('no_fee')
    else
      @buildings = buildings
    end
    @buildings
  end

  def self.has_amenity?(name)
    @amenities.include?(name)
  end

  def self.search_by_zipcodes(criteria)
    #regexp = /#{criteria}/i;
    results = Building.search_by_zipcode(criteria).order(:zipcode).to_a.uniq(&:zipcode)
    #results.sort{|x, y| (x =~ regexp) <=> (y =~ regexp) } 
  end

  def self.search_by_pneighborhoods(criteria)
    #regexp = /#{criteria}/i; remove due to RegexpError: premature end of char-class: /river [a/i
    results = Building.search_by_pneighborhood(criteria).order(:neighborhoods_parent).to_a.uniq(&:neighborhoods_parent)
    #results.sort{|x, y| (x =~ regexp) <=> (y =~ regexp) } 
  end

  def self.search_by_building_name(criteria)
    results = Building.text_search_by_building_name(criteria).reorder('building_name ASC')
  end

  def self.buildings_in_neighborhood params
    where("neighborhood = ? or neighborhoods_parent = ? or neighborhood3 = ?" , params[:neighborhoods], params[:neighborhoods], params[:neighborhoods])
  end

  def self.buildings_in_city params, city
    where("city @@ :q" , q: city)
  end

  #Contribute search method
  def self.text_search(term)
    if term.present?
      search(term)
    else
      self.all
    end
  end

  def recommended_percent
    Vote.recommended_percent(self)
  end

  def zipcode=(val)
    write_attribute(:zipcode, val.to_s.gsub(/\s+/,'')) if val.present?
  end

  def street_address
    [building_street_address, city, state].compact.join(', ')
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

  def rating_cache
    RatingCache.where(cacheable_id: self.id, cacheable_type: 'Building') 
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

  def self.number_of_buildings neighbohood
    where("neighborhood @@ :q or neighborhoods_parent @@ :q or neighborhood3 @@ :q" , q: neighbohood).count
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
    neighborhood1 = neighborhood2 = neighborhood3 = ''
    if search.present?
      #search for child neighborhoods
      search[0..4].each_with_index do |geo_result, index|
        #finding neighborhood
        neighborhood = geo_result.address_components_of_type(:neighborhood)
        if neighborhood.present?
          neighborhood = neighborhood.first['long_name']
          locality = search[0].address_components_of_type(:sublocality).first['long_name']
          #checking main neighborhood
          if ['Queens','Brooklyn','Bronx'].include?(locality) and self.city == neighborhood
            neighborhood1 = neighborhood
          elsif predifined_neighborhoods.include? neighborhood
            neighborhood1 = neighborhood if neighborhood1.blank?
            #neighborhood2 = neighborhood if neighborhood2.blank?
          elsif just_parent_neighborhoods.include? neighborhood
            neighborhood2 = neighborhood
          elsif parent_neighborhoods.include? neighborhood #checking parent of main neighborhood
            neighborhood2 = neighborhood if neighborhood2.blank?
            neighborhood1 = neighborhood if neighborhood1.blank? and index >= 2
          elsif grandparent_neighborhoods.include? neighborhood #checking grandparent of main neighborhood
            neighborhood3 = neighborhood
            #neighborhood1 = neighborhood if neighborhood1.blank?
            neighborhood2 = neighborhood if neighborhood2.blank? and neighborhood1.blank?
          end
          #end if
        end

      end #end search loop
      
    end #end seaech if

    return neighborhood1, neighborhood2, neighborhood3
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
      #if self.neighborhood != neighborhoods[0] or self.neighborhoods_parent != neighborhoods[1]
      self.update_columns(neighborhood: neighborhoods[0], neighborhoods_parent: neighborhoods[1], neighborhood3: neighborhoods[2] )
      #end
    end
  end

end
