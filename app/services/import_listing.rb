class ImportListing < ImportService

  def initialize file
    super
  end
  
  def create_listing building, row, line_num
    listing = Listing.new
    listing.attributes            = row.to_hash
    listing[:building_id]         = building.id
    listing[:management_company]  = building.management_company_name if building.management_company.present?
    if listing.save
      building.update_rent(building.listings)
    else
      listing.errors.full_messages.each do |message|
        @errors << "Issue line #{line_num}, column #{message}."
      end
    end
  end

  def find_building buildings, address
    buildings.where('LOWER(building_street_address) = ?', address.downcase.strip)
  end

  def import_listings buildings
    @errors = []
    (2..@spreadsheet.last_row).each do |i|
      row = Hash[[@header, @spreadsheet.row(i)].transpose ]
      address = row['building_address']
      if address.present? && row['unit'].present? && row['date_active'].present?
        building = find_building(buildings, address)
        if building.present?
          create_listing(building.first, row, i)
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
    missing_text += ', Date active'   if row['date_active'].blank?
    missing_text += ', Unit'          if row['unit'].blank?
    return missing_text
  end
end