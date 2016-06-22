class Unit < ActiveRecord::Base
	acts_as_votable
	ratyrate_rateable "unit"
	
	validates :name, presence: true
  
	belongs_to :building
	has_many :reviews, as: :reviewable

	has_many :uploads, as: :imageable
  accepts_nested_attributes_for :uploads, :allow_destroy => true
end
