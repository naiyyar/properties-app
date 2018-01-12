class Upload < ActiveRecord::Base
	attr_accessor :rotation_degrees, :rotate
	resourcify
	belongs_to :imageable, polymorphic: true
  has_many :document_downloads
  belongs_to :user
	#before_create :set_defaults
  default_scope { order('sort asc') }

	has_attached_file :image, 
                    :styles => { :medium => "300x300>", :thumb => "100x100>", :original => '' },
                    processors: [:rotator]
	
	validates_attachment :image, 
                				# :presence => true,
                				:content_type => { :content_type => ["image/jpeg", "image/gif", "image/png"] }
  
  has_attached_file :document
  validates_attachment  :document, 
                        # :presence => true,
                        :content_type => { :content_type => ["application/pdf","application/vnd.ms-excel",     
                                           "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
                                           "application/msword", 
                                           "application/vnd.openxmlformats-officedocument.wordprocessingml.document", 
                                           "text/plain"] }
  #after_update :rename_file
  #before_update :rename_file
  #and (in my case, the paperclip attachement name is "file")

  # def rename_file
  #   #debugger
  #   self.document = open(self.document.url)
  #   self.document.instance_write(:file_name, '1234')
  #   self.save
  # #   #self.document.instance_write(:file_name, params[:upload][:document_file_name])
  # #   Upload.where(id: params[:id]).each do |m|
  # #     [:original].each do |style|
  # #       s3 = AWS::S3.new
  # #       key = "uploads/#{m.id}/#{style}/#{m.document_file_name}"
  # #       object = s3.buckets[:bucket_name].objects[key]
  # #       next unless object.exists?
  # #       hash = m.document.hash_key style
  # #       copy_key = "m/#{m.id}/#{hash}/#{m.document_file_name}"
  # #       puts "Copying to #{copy_key}"
  # #       object.copy_to(copy_key, acl: :public_read)
  # #     end
  # #   end
  # end

  def self.image_uploads_count object
    object.uploads.where('image_file_name is not null').count
  end

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

  # def is_video?
  #   image.instance.attachment_content_type =~ %r(video)
  # end
end
