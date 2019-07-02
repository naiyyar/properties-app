# == Schema Information
#
# Table name: useful_reviews
#
#  id         :integer          not null, primary key
#  review_id  :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UsefulReview < ApplicationRecord
	belongs_to :review
	belongs_to :user
end
