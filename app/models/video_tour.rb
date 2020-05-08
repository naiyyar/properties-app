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
end
