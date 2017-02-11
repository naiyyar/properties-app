class Unit < ActiveRecord::Base
	acts_as_voteable
	ratyrate_rateable "unit"
	resourcify
	validates :name, presence: true
  
	belongs_to :building
	has_many :reviews, as: :reviewable
	has_many :rental_price_histories

	has_many :uploads, as: :imageable
  	accepts_nested_attributes_for :uploads, :allow_destroy => true

  	default_scope { order('updated_at desc') } 

  	def self.search(term)
	    if term
	      self.where("name ILIKE ?", "%#{term}%")
	    else
	      self.all
	    end
  	end
end
