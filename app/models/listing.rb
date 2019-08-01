class Listing < ApplicationRecord
	include PgSearch
	belongs_to :building

	delegate :management_company, to: :building

	scope :active, -> { where(active: true) }
	scope :inactive, -> { where(active: false) }

  pg_search_scope :search_query, 
  								against: [:building_address, :management_company],
                  associated_against: {
                    building: [:building_name]
                  }

  								
  default_scope { order(date_active: :desc, management_company: :asc, building_address: :asc, unit: :asc)}

  validates_presence_of :building_address, :unit, :date_active
	
	filterrific(
   default_filter_params: { },
   available_filters: [
     	:search_query
    ]
  )

  after_save :create_unit, unless: :unit_exist?
  after_update :create_unit, unless: :unit_exist?

  def management_company_name
    management_company.try(:name)
  end

  def unit_exist?
  	building.units.where(name: unit).present?
  end

  def self.import_listings file
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    errors = []
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose ]
      if row['building_address'].present? and row['unit'].present? and row['date_active'].present?
        @building = Building.where(building_street_address: row['building_address'])
        @building = Building.where('building_street_address @@ :q', q: row['building_address']) if @building.blank?
        if @building.present?
          listing = Listing.new
          listing.attributes = row.to_hash #.slice(*row.to_hash.keys[5..8]) #excluding building specific attributes
          listing[:building_id] = @building.first.id
          listing[:building_address] = @building.first.building_street_address
          listing[:management_company] = @building.first.management_company.try(:name)
          listing[:date_active] = !row['date_active'].kind_of?(Date) ? DateTime.parse(row['date_active']) : row['date_active']
          listing[:unit] = row['unit']
          listing[:rent] = row['rent']
          listing[:bed]  = row['bed']
          listing[:bath] = row['bath']
          listing[:free_months] = row['free_months']
          listing[:owner_paid] = row['owner_paid']
          listing[:rent_stabilize] = row['rent_stabilize'] || false
          listing[:date_available] = !row['date_available'].kind_of?(Date) ? DateTime.parse(row['date_available']) :row['date_available']
          if listing.save!
          else
            listing.errors.full_messages.each do |message|
              errors << "Issue line #{i}, column #{message}."
            end
          end
        else
          errors << 'Building Not present in database.'
        end
      else
        missing_text = ''
        missing_text = 'Building address' if row['building_address'].blank?
        missing_text += ', Date active' if row['date_active'].blank?
        missing_text += ', Unit' if row['unit'].blank?
        
        errors << "Issue line #{i}, #{missing_text} is missing."
      end
    end
    errors
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
     when '.csv' then Roo::CSV.new(file.path)
     when '.xls' then Roo::Excel.new(file.path)
     when '.xlsx' then Roo::Excelx.new(file.path)
     else raise "Unknown file type: #{file.original_filename}"
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
