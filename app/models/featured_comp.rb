class FeaturedComp < ActiveRecord::Base
	include PgSearch
	validates_uniqueness_of :comp_id
	belongs_to :building
	#belongs_to :sender, :foreign_key => :sender_id, class_name: 'User'
	has_many :featured_buildings
	has_many :buildings, through: :featured_buildings, :dependent => :destroy

	pg_search_scope :search_query, against: [:comp_id],
    :using => { :tsearch => { prefix: true } }

	filterrific(
   default_filter_params: { },
   available_filters: [
     :search_query
    ]
  )

  def add_featured_building building_ids
  	building_ids.reject{|c| c.empty?}.map do |id|
  		self.featured_buildings.create(building_id: id)
  	end
	end
end
