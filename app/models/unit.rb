class Unit < ActiveRecord::Base
	acts_as_voteable
	ratyrate_rateable 'unit'
	resourcify
	validates_uniqueness_of :name, scope: [:id, :building_id], presence: true
  
	belongs_to :building
	has_many :reviews, as: :reviewable
	has_many :rental_price_histories, dependent: :destroy
	belongs_to :user

	include Imageable
  include Amenitable

	default_scope { order('updated_at desc') }

	def to_param
    if name.present?
      "#{id} #{name}".parameterize.upcase
    end
  end 

	def self.search(term)
    if term
      self.where("name ILIKE ?", "%#{term}%")
    else
      self.all
    end
	end

	def recommended_percent
		Vote.recommended_percent(self)
	end

	def image_uploads
    self.uploads.where('image_file_name is not null')
  end

  def bedrooms
  	if number_of_bedrooms == 0
  		'Studio'
  	elsif number_of_bedrooms == 4
  		'4+ Bedrooms'
  	else
  		"#{number_of_bedrooms} Bedrooms"
  	end
  end

  # balcony: 'Balcony',
  # board_approval_required: 'Board Approval Required',
  # can_be_converted: 'Can be converted',
  # converted_unit: 'Converted Unit',
  # dishwasher: 'Dishwasher',
  # fireplace: 'Fireplace',
  # furnished: 'Furnished',
  # guarantors_accepted: 'Guarantors Accepted',
  # loft: 'Loft',
  # private_landlord: 'Private Landlord',
  # rent_controlled: 'Rent Controlled',
  # storage_available: 'Storage Available',
  # sublet: 'Sublet',
  # terrace: 'Terrace',
  # dryer_in_unit: 'Washer/Dryer'

  def save_amenities
    if self.balcony
      self.amenities.create!(name: 'Balcony')
    end
    if self.board_approval_required
      self.amenities.create!(name: 'Board Approval Required')
    end
    if self.can_be_converted
      self.amenities.create!(name: 'Can be converted')
    end
    if self.converted_unit
      self.amenities.create!(name: 'Converted Unit')
    end
    if self.dishwasher
      self.amenities.create!(name: 'Dishwasher')
    end
    if self.fireplace
      self.amenities.create!(name: 'Fireplace')
    end
    if self.furnished
      self.amenities.create!(name: 'Furnished')
    end
    if self.guarantors_accepted
      self.amenities.create!(name: 'Guarantors Accepted')
    end
    if self.loft
      self.amenities.create!(name: 'Loft')
    end
    if self.private_landlord
      self.amenities.create!(name: 'Private Landlord')
    end
    if self.rent_controlled
      self.amenities.create!(name: 'Rent Controlled')
    end
    if self.storage_available
      self.amenities.create!(name: 'Storage Available')
    end
    if self.sublet
      self.amenities.create!(name: 'Sublet')
    end
    if self.terrace
      self.amenities.create!(name: 'Terrace')
    end
    if self.dryer_in_unit
      self.amenities.create!(name: 'Washer/Dryer')
    end
    
  end

end
