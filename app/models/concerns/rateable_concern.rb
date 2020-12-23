module RateableConcern
	extend ActiveSupport::Concern
	
	DIMENSIONS  = ['cleanliness','noise','safe','health','responsiveness','management']

	included do

	end

	def rating_cache?
    rating_cache.where(dimension: DIMENSIONS).size > 0
  end

  def rating_cache
    @ratings_cache ||= RatingCache.where(cacheable_id: self.id, cacheable_type: self.class.name) 
  end
end