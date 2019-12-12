class ImportListing < ImportService

	def initialize file
		super
	end
	
	def create_listing row, line_num
		listing = Listing.new
    listing.attributes 						= row.to_hash
    listing[:building_id] 				= @building.first.id
    listing[:building_address] 		= @building.first.building_street_address
    listing[:management_company] 	= @building.first.management_company.try(:name)
    listing[:date_active] 				= row['date_active']
    listing[:unit] 								= row['unit']
    listing[:rent] 								= row['rent']
    listing[:bed]  								= row['bed']
    listing[:bath] 								= row['bath']
    listing[:free_months] 				= row['free_months']
    listing[:owner_paid] 					= row['owner_paid']
    listing[:rent_stabilize] 			= row['rent_stabilize'].to_s
    listing[:date_available] 			= row['date_available']
    if listing.save
      listing.update_rent
    else
      listing.errors.full_messages.each do |message|
        @errors << "Issue line #{line_num}, column #{message}."
      end
    end
	end

	def get_building address
		Building.where(building_street_address: address)
		Building.where('building_street_address @@ :q', q: address) if @building.blank?
	end

	def import_listings
    @errors = []
    (2..@spreadsheet.last_row).each do |i|
      row = Hash[[@header, @spreadsheet.row(i)].transpose ]
      if row['building_address'].present? and row['unit'].present? and row['date_active'].present?
        @building = get_building(row['building_address'])
        if @building.present?
          create_listing(row, i)
        else
          @errors << "Issue line #{i}, Building address does not exist in database."
        end
      else
        @errors << "Issue line #{i}, #{missing_text_error_messages(row)} is missing."
      end
    end
    @errors
  end

  def missing_text_error_messages row
  	missing_text = ''
    missing_text = 'Building address' if row['building_address'].blank?
    missing_text += ', Date active' 	if row['date_active'].blank?
    missing_text += ', Unit' 					if row['unit'].blank?
    return missing_text
  end
end