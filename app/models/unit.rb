class Unit < ActiveRecord::Base
	acts_as_voteable
	ratyrate_rateable 'unit'
	resourcify
	validates_uniqueness_of :name, scope: [:id, :building_id], presence: true
  
	belongs_to :building
	has_many :reviews, as: :reviewable
	has_many :rental_price_histories
	belongs_to :user

  	include Imageable

  	default_scope { order('updated_at desc') } 

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

end
