class Upload < ActiveRecord::Base
	attr_accessor :rotation_degrees, :rotate

	resourcify
	belongs_to :imageable, polymorphic: true
  has_many :document_downloads
  belongs_to :user
	#before_create :set_defaults

	has_attached_file :image, 
                    :styles => { :medium => "300x300>", :thumb => "100x100>", :original => '' },
                    processors: [:rotator]                    

	default_scope { order('sort asc') }
	
	validates_attachment 	:image, 
                				# :presence => true,
                				:content_type => { :content_type => /\Aimage\/.*\Z/ }
  
  has_attached_file :document
  validates_attachment  :document, 
                        # :presence => true,
                        :content_type => { :content_type => ["application/pdf","application/vnd.ms-excel",     
                                           "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                           "application/msword", 
                                           "application/vnd.openxmlformats-officedocument.wordprocessingml.document", 
                                           "text/plain"] }

	def self.marker_image object
    no_image = 'no-photo.png'
    if object.uploads.present?
      object.uploads.last.image_file_name.present? ? object.uploads.last.image : no_image
    else
      no_image
    end
	end

  def total_downloads
    self.document_downloads.count
  end

	def rotate!(degrees = 90)
    self.rotation += degrees
    self.rotation -= 360 if self.rotation >= 360
    self.rotation += 360 if self.rotation <= -360
    
    self.rotate = true
    self.image.reprocess!
    self.image_updated_at = Time.now # Update timestamp to prevent browser from using cached image
    self.save
  end
  
  def rotating?
    !self.rotation.nil? and self.rotate
  end

  private
  def set_defaults
    self.rotation ||= 0
  end
end
