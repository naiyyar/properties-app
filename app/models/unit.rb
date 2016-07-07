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
end
