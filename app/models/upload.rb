class Upload < ActiveRecord::Base
	resourcify
	belongs_to :imageable, polymorphic: true

	has_attached_file :image, :styles => { :medium => "300x300>",:thumb => "100x100>" }
	
	validates_attachment 	:image, 
				:presence => true,
				:content_type => { :content_type => /\Aimage\/.*\Z/ }

	def self.marker_image object
	    no_image = 'no-photo.png'
	    if object.uploads.present?
	      object.uploads.last.image_file_name.present? ? object.uploads.last.image : no_image
	    else
	      no_image
	    end
	end
end
