module ImportBuildingReviews
	def import_reviews file
    user = User.find_by_email('reviews@transparentcity.co')
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose ]
      if row['building_address'].present?
        @buildings = where(building_street_address: row['building_address'], zipcode: row['zipcode'])
        unless @buildings.present?
          @building = create_building(row)
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

  def open_spreadsheet(file)
    case File.extname(file.original_filename)
     when '.csv' then Roo::CSV.new(file.path)
     when '.xls' then Roo::Excel.new(file.path)
     when '.xlsx' then Roo::Excelx.new(file.path)
     else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def create_building row
  	Building.create({ building_street_address: row['building_address'], 
                      city: row['city'], 
                      state: 'NY', 
                      zipcode: row['zipcode']
                    })
  end
end