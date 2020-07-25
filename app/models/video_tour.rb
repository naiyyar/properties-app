# == Schema Information
#
# Table name: uploads
#
#  id                    :integer          not null, primary key
#  building_id       		 :integer
#  url    							 :string
#  description       		 :string
#  category      				 :string
#  sort          				 :integer
#

class VideoTour < ApplicationRecord
	belongs_to :building
	
	CATEGORIES = [['Amenities', 	'amenities'], 
								['Studio', 			'studio'], 
								['1 Bedroom', 	'1-bedroom'],
								['2 Bedroom', 	'2-bedroom'], 
								['3 Bedroom', 	'3-bedroom'], 
								['4+ Bedroom', 	'4-bedroom']]
	
	validates_presence_of   :url, message: 'Url can not be blank.'
	validates_uniqueness_of :url, scope: :building_id, message: 'Url has already been taken.'

	default_scope { order('sort asc') }

	def self.videos_by_categories videos, loaded_category=nil
		categories  = videos.pluck(:category)
		category    = categories.include?('amenities') ? 'amenities' : categories.uniq.sort.first
		video_tours = unless loaded_category.present?
                    videos.where(category: category)
                  else
                    videos.where.not(category: loaded_category)
                  end
    video_tours = video_tours.group_by{|v| v.category}
    return video_tours, category
	end
end
