class Building < ActiveRecord::Base
  acts_as_voteable
  validates :building_street_address, presence: true
  validates_uniqueness_of :building_street_address, scope: :zipcode
  validates_uniqueness_of :building_name, :allow_blank => true, :allow_nil => true
  resourcify
  ratyrate_rateable "building"
  
  has_many :reviews, as: :reviewable
  has_many :units,  :dependent => :destroy
  has_many :uploads, as: :imageable
  accepts_nested_attributes_for :uploads, :allow_destroy => true
  accepts_nested_attributes_for :units, :allow_destroy => true

  #has_attached_file :photo, styles: { large: "600x600>", medium: "400x400>", thumb: "100x100>", small: "32x32>" }
  #validates_attachment_content_type :photo, content_type: /\Aimage\/.*\Z/

  geocoded_by :street_address
  after_validation :geocode

  #
  after_create :save_neighborhood
  after_update :update_neighborhood

  include PgSearch
  pg_search_scope :search, against: [:building_name, :building_street_address],
    :using => { :trigram => {
                  :threshold => 0.1
                }
              }
  pg_search_scope :text_search_by_building_name, against: [:building_name],
    :using => { :trigram => {
                  :threshold => 0.1
                }
              }
  pg_search_scope :search_by_street_address, against: [:building_street_address],
    :using => { :trigram => { :threshold => 0.1 } }

  pg_search_scope :text_search_by_city, against: [:city],
    :using => { :trigram => { :threshold => 0.1 } }

  pg_search_scope :text_search_by_neighborhood, against: [:neighborhood],
    :using => { :trigram => { :threshold => 0.1 } }

  pg_search_scope :text_search_by_parent_neighborhood, against: [:neighborhoods_parent],
    :using => { :trigram => { :threshold => 0.1 } }


  def zipcode=(val)
    write_attribute(:zipcode, val.gsub(/\s+/,''))
  end

  def street_address
    [building_street_address, city, state].compact.join(', ')
  end

  def building_name_or_address
    self.building_name.present? ? self.building_name : street_address
  end

  def self.text_search(term)
    if term.present?
      search(term)
    else
      self.all
    end
  end

  def self.text_search_by_zipcode search_term
    where('zipcode @@ :q', q: search_term)
  end

  def self.buildings_in_neighborhood params
    where("neighborhood @@ :q or neighborhoods_parent @@ :q" , q: "%#{params[:neighborhoods]}").paginate(:page => params[:page], :per_page => 5) #.to_a.uniq(&:building_street_address)
  end

  def fetch_or_create_unit params
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

  #child neighbohoods
  def predifined_neighborhoods
    arr = []
    File.open("#{Rails.root}/public/neighborhoods.txt", "r").each_line do |line|
      arr << line.split(/\n/)
    end
    return arr.flatten
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
    ['Lower Manhattan', 'Upper Manhattan']
  end

  private

  def neighborhoods
    search = Geocoder.search([latitude, longitude])
    child_neighborhoods = nil
    neighborhoods_parent = nil
    if search.present?
      #search for child neighborhoods
      search[0..3].each do |geo_result|
        neighborhood = geo_result.address_components_of_type(:neighborhood)
        if neighborhood.present?
          neighborhood = neighborhood.first['long_name']
          unless child_neighborhoods.present?
            if predifined_neighborhoods.include? neighborhood
              child_neighborhoods = neighborhood #child neighborhoods
            end
          end
          #parent neighborhoods
          #unless neighborhoods_parent.present?
            if parent_neighborhoods.include? neighborhood
              neighborhoods_parent = neighborhood
            elsif grandparent_neighborhoods.include? neighborhood
              neighborhoods_parent = neighborhood
            else
              search_result = search.first.address_components_of_type(:neighborhood)
              neighborhoods_parent = search_result.first['long_name'] if search_result.present?
            end
          #end
        end
      end
      
      #search for midtown parent neighborhoods if nothning find for child
      if child_neighborhoods.blank?
        search[0..3].each do |geo_result|
          neighborhood = geo_result.address_components_of_type(:neighborhood)
          if neighborhood.present?
            neighborhood = neighborhood.first['long_name']
            if parent_neighborhoods.include? neighborhood
              child_neighborhoods = neighborhood
            end
          end
        end
      end
      
      if child_neighborhoods.present?
        child_neighborhoods = child_neighborhoods
      else
        child_neighborhoodschild_neighborhoods = search.first.address_components_of_type(:neighborhood)
        if child_neighborhoods.present?
          child_neighborhoods = child_neighborhoods.first['long_name']
        else
          type_locality = search.first.address_components_of_type(:locality)
          if type_locality.present?
            child_neighborhoods = type_locality.first['long_name']
          else
            child_neighborhoods = ''
          end
        end
      end
    end
    return child_neighborhoods, neighborhoods_parent
  end

  def save_neighborhood
    if neighborhoods.present?
      self.neighborhood = neighborhoods[0]
      self.neighborhoods_parent = neighborhoods[1]
      self.save
    end
  end

  def update_neighborhood
    self.update_columns(neighborhood: neighborhoods[0], neighborhoods_parent: neighborhoods[1] ) if neighborhoods.present?
  end

end
