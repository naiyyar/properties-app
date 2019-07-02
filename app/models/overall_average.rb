# == Schema Information
#
# Table name: overall_averages
#
#  id            :integer          not null, primary key
#  rateable_id   :integer
#  rateable_type :string
#  overall_avg   :float            not null
#  created_at    :datetime
#  updated_at    :datetime
#

class OverallAverage < ApplicationRecord
  belongs_to :rateable, :polymorphic => true
end

