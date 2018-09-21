# == Schema Information
#
# Table name: review_flags
#
#  id               :integer          not null, primary key
#  review_id        :integer
#  user_id          :integer
#  flag_description :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class ReviewFlag < ActiveRecord::Base
	belongs_to :review
	belongs_to :user
end
