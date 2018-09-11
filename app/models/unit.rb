class Unit < ActiveRecord::Base
	acts_as_voteable
	ratyrate_rateable 'unit','cleanliness','noise','safe','health','responsiveness','management'
	resourcify
	validates_uniqueness_of :name, scope: [:id, :building_id], presence: true
  
	belongs_to :building
	has_many :reviews, as: :reviewable
	has_many :rental_price_histories, dependent: :destroy
	belongs_to :user

	include Imageable

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

	def upvotes_count
    self.votes.where(vote: true).count
  end

  def downvotes_count
    self.votes.where(vote: false).count
  end

  def total_votes
    self.votes.count
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

end
