# == Schema Information
#
# Table name: rating_caches
#
#  id             :integer          not null, primary key
#  cacheable_id   :integer
#  cacheable_type :string
#  avg            :float            not null
#  qty            :integer          not null
#  dimension      :string
#  created_at     :datetime
#  updated_at     :datetime
#

class RatingCache < ActiveRecord::Base
  belongs_to :cacheable, :polymorphic => true

  def self.update_rating_cache rating_cache
  	rateables = Rate.where(dimension: rating_cache.dimension, 
  													rateable_id: rating_cache.cacheable_id, 
  													rateable_type: rating_cache.cacheable_type)
  	
  	#rating_cache = rating_cache.first
    rating_cache.avg = rateables.sum(:stars)/rateables.count
    rating_cache.qty = rateables.count
    rating_cache.save
  end

end
