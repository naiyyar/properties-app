class RatingCache < ActiveRecord::Base
  belongs_to :cacheable, :polymorphic => true

  def self.update_rating_cache rating_cache, rateables
  	rating_cache = rating_cache.first
    rating_cache.avg = rateables.sum(:stars)/rateables.count
    rating_cache.qty = rateables.count
    rating_cache.save
  end

end