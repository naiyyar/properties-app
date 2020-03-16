# == Schema Information
#
# Table name: rates
#
#  id            :integer          not null, primary key
#  rater_id      :integer
#  rateable_id   :integer
#  rateable_type :string
#  stars         :float            not null
#  dimension     :string
#  created_at    :datetime
#  updated_at    :datetime
#  review_id     :integer
#

class Rate < ApplicationRecord
  belongs_to :rater, 		:class_name => 'User'
  belongs_to :rateable, :polymorphic => true

  def self.rateables managed_buildings
    where(rateable_id: 		managed_buildings.pluck(:id), 
    			rateable_type: 	'Building', 
    			dimension: 			'building')
  end

end
