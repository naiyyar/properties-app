class Building < ActiveRecord::Base

  include PgSearch
  include Imageable
  include Amenitable
  acts_as_voteable
  resourcify
  ratyrate_rateable 'building','cleanliness','noise','safe','health','responsiveness','management'

  validates :building_street_address, presence: true
  validates_uniqueness_of :building_street_address, scope: [:zipcode]

  belongs_to :user
  has_many :reviews, as: :reviewable
  has_many :units,  :dependent => :destroy
  
  accepts_nested_attributes_for :units, :allow_destroy => true

  default_scope { order('created_at desc') }

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

  def create_or_update_amenities building_params
    amenities = ApplicationController.helpers.building_amenities
    building_params.each_pair do |key, value|
      if building_params[:elevator].to_i > 0 and key == 'elevator'
        @elevators = (amenities[key.to_sym] == 'Elevator' ? building_params[:elevator] : nil)
        rec = self.amenities.where(name: 'Elevator').first_or_initialize
        rec.name = 'Elevator'
        rec.number_of_elevators = @elevators
        rec.save
      end
      
      if value == '1'
        amen_name = amenities[key.to_sym]
        self.amenities.where(name: amen_name).first_or_initialize do |rec|
          rec.name = amenities[key.to_sym] 
          rec.save
        end
      end
    end
  end

  def save_amenities
    a_name = ''
    if self.laundry_facility
      a_name = 'Laundry in Building'
      self.amenities.create!(name: a_name)
    end
    
    if  self.courtyard
      a_name = 'Courtyard'
      self.amenities.create!(name: a_name)
    end
    
    if  self.pets_allowed_dogs
      a_name = 'Dogs Allowed'
      self.amenities.create!(name: a_name)
    end

    if  self.pets_allowed_cats
      a_name = 'Cats Allowed'
      self.amenities.create!(name: a_name)
    end

    if  self.doorman
      a_name = 'Doorman'
      self.amenities.create!(name: a_name)
    end

    if  self.elevator.present?
      a_name = 'Elevator'
      self.amenities.create!(name: a_name, number_of_elevators: self.elevator.to_i)
    end

    if  self.garage
      a_name = 'Garage'
      self.amenities.create!(name: a_name)
    end

    if  self.gym
      a_name = 'Gym'
      self.amenities.create!(name: a_name)
    end

    if  self.live_in_super
      a_name = 'Live in super'
      self.amenities.create!(name: a_name)
    end

    if  self.management_company_run
      a_name = 'Management Company Run'
      self.amenities.create!(name: a_name)
    end

    if  self.roof_deck
      a_name = 'Roof Deck'
      self.amenities.create!(name: a_name)
    end

    if  self.parking
      a_name = 'Parking'
      self.amenities.create!(name: a_name)
    end

    if  self.swimming_pool
      a_name = 'Swimming Pool'
      self.amenities.create!(name: a_name)
    end
    
    if  self.walk_up
      a_name = 'Walk up'
      self.amenities.create!(name: a_name)
    end
    
    if self.childrens_playroom
      a_name = 'Childrens Playroom'
      self.amenities.create!(name: a_name)
    end
    
    if  self.no_fee
      a_name = 'No Fee Building'
      self.amenities.create!(name: a_name)
    end
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
      buildings = buildings.reorder('building_name ASC')
    when '5'
      buildings = buildings.reorder('building_name DESC')
    else
      buildings = buildings
    end
    buildings
  end

  def self.sort_by_rating buildings, sort_index
    if sort_index == '1'
      @ratings = RatingCache.where(cacheable_id: buildings.map(&:id)).order('avg desc')
    else
      @ratings = RatingCache.where(cacheable_id: buildings.map(&:id)).order('avg asc')
    end
    building_ids = @ratings.map(&:cacheable_id)
    buildings = buildings.where(id: building_ids).to_a.sort_by{ |b| building_ids.index(b.id) }
    buildings
  end

  def self.filter_by_rates buildings, rating
    if rating.present?
      rates = RatingCache.where(cacheable_type: 'Building', avg: rating)
      buildings.where('id in (?)', rates.map(&:cacheable_id))
    else
      buildings
    end
  end

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
    if amenities.present?
      @building = buildings.where(id: Amenity.where(name: amenities).map(&:amenitable_id))
    else
      @buildings = buildings
    end
    @building
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
