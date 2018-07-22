class Rate < ActiveRecord::Base
  belongs_to :rater, :class_name => "User"
  belongs_to :rateable, :polymorphic => true

  #attr_accessible :rate, :dimension


  def self.get_average_stars buildings
  	@total_rates = 0
    star_counts = []
    buildings_count = buildings.count
    buildings.each do |building|
      rating_cache = building.rating_cache
      if rating_cache.present?
        @total_rates += rating_cache.first.avg if rating_cache.present?
      end
    end
    star_counts = (@total_rates.to_f/buildings_count).round(2).to_s.split('.')
    return star_counts
  end

end