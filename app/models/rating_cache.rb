class RatingCache < ApplicationRecord
  belongs_to :cacheable, :polymorphic => true

  def self.update_rating_cache rating_cache
  	rateables = Rate.where( dimension:     rating_cache.dimension, 
  													rateable_id:   rating_cache.cacheable_id, 
  													rateable_type: rating_cache.cacheable_type)
  	
    rating_cache.avg = rateables.sum(:stars) / rateables.count
    rating_cache.qty = rateables.count
    rating_cache.save

    rating_cache.update_building_avg
  end

  def update_building_avg
    return unless dimension == 'building'
    Building.where(id: cacheable_id).update_all(avg_rating: self.avg)
  end

  def self.create_rating_cache rateable, rateables, dimension
    rating_cache = RatingCache.create(  cacheable_id:   rateable.id,
                                        cacheable_type: rateable.class.name,
                                        dimension:      dimension,
                                        avg:            rateables.sum(:stars) / rateables.count,
                                        qty:            rateables.count)
    # updating avg in building table
    rating_cache.update_building_avg
  end

end
