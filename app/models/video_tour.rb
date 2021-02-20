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
#  image_file_name       :string
#  image_content_type    :string
#  image_file_size       :integer
#  image_updated_at      :datetime
#  tourable_id      		 :integer
#  tourable_type      	 :string
#

class VideoTour < ApplicationRecord
	belongs_to :tourable, polymorphic: true, touch: true
	
	CATEGORIES = [['Amenities', 	'amenities'], 
								['Studio', 			'studio'], 
								['1 Bedroom', 	'1-bedroom'],
								['2 Bedroom', 	'2-bedroom'], 
								['3 Bedroom', 	'3-bedroom'], 
								['4+ Bedroom', 	'4-bedroom']].freeze
	
	validates_presence_of   :url, message: 'Url can not be blank.'
	validates_uniqueness_of :url, scope: [:tourable_id, :tourable_type], message: 'Url has already been taken.', on: :create


	has_attached_file :image
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

	default_scope { order('sort asc') }

	class << self
		def categories videos
			videos.pluck(:category).uniq #.sort
		end

		def first_category videos
			cats = categories(videos)
			cats.include?('amenities') ? 'amenities' : cats.first
		end

		def second_category videos
			cats = categories(videos)
			cats.include?('studio') ? 'studio' : cats[1]
		end

		def videos_by_categories videos, options={}
			video_tours = unless options.empty?
	                    first_2_videos(videos)
	                  else
	                    videos.where.not(category: nil)
	                  end
	    video_tours = video_tours.group_by{|v| v.category}
	    return video_tours, first_category(videos)
		end

		def first_2_videos videos
			tour_videos = videos.where(category: first_category(videos)).limit(2)
	    return tour_videos if tour_videos.length >= 2
	    videos.where(category: [first_category(videos), second_category(videos)]).limit(2)
		end
	end #class methods

end
