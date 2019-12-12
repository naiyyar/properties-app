class ImportReviews < ImportService

	def initialize file
		super
		@user = User.find_by_email('reviews@transparentcity.co')
	end

	def create_review row
		rev = Review.new
    rev.attributes = row.to_hash.slice(*row.to_hash.keys[5..8]) #excluding building specific attributes
    
    rev[:reviewable_id] 	= @building.id
    rev[:reviewable_type] = 'Building'
    rev[:anonymous] 			= true
    rev[:created_at] 			= DateTime.parse(row['created_at'])
    rev[:updated_at] 			= DateTime.parse(row['created_at'])
    rev[:user_id] 				= @user.id
    rev[:tos_agreement] 	= true
    rev[:scraped] 				= true
    rev.save!
    #row['rating'] => score
    save_votes(row) if rev.present? and rev.id.present?
	end

	def save_votes row
		@user.create_rating(row['rating'], @building, rev.id, 'building')
    if row['vote'].present? and row['vote'] == 'yes'
      @vote = @user.vote_for(@building)
    else
      @vote = @user.vote_against(@building)
    end
    
    if @vote.present?
      @vote.review_id = rev.id
      @vote.save
    end
	end

	def get_buildings row
		Building.where(building_street_address: row['building_address'], zipcode: row['zipcode'])
	end

	def import_reviews
    (2..@spreadsheet.last_row).each do |i|
      row = Hash[[@header, @spreadsheet.row(i)].transpose ]
      if row['building_address'].present?
        @buildings = get_buildings(row)
        unless @buildings.present?
          @building = create_building(row)
        else
          @building = @buildings.first
        end
        create_review(row) if @building.present? and @building.id.present?
      end
    end
  end

  def create_building row
  	Building.create({ 
  										building_street_address: 	row['building_address'], 
                      city: 										row['city'], 
                      state: 										'NY', 
                      zipcode: 									row['zipcode']
                    })
  end

end