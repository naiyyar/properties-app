class UsefulReview < ActiveRecord::Base
	belongs_to :review
	belongs_to :user
end
