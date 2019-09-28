# == Schema Information
#
# Table name: uploads
#
#  id                    :integer          not null, primary key
#  image_file_name       :string
#  image_content_type    :string
#  image_file_size       :integer
#  image_updated_at      :datetime
#  imageable_id          :integer
#  imageable_type        :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :integer
#  sort                  :integer
#  rotation              :integer          default(0), not null
#  document_file_name    :string
#  document_content_type :string
#  document_file_size    :integer
#  document_updated_at   :datetime
#  file_uid              :string
#

class Upload < ApplicationRecord
	attr_accessor :rotation_degrees, :rotate
	resourcify
	belongs_to :imageable, polymorphic: true, touch: true
  has_many :document_downloads
  belongs_to :user
	#before_create :set_defaults
  default_scope { order('sort asc') }

	has_attached_file :image, 
                    :styles => { :original => '900x800', :medium => '650x550' },
                    #:convert_options => {:medium => '-quality 80 -strip' },
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

  after_create :set_sort_index

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

  def self.uploads_json_hash(uploads)
    uploads.as_json(:methods => [:date_uploaded, :orig_image_url])
  end

  def date_uploaded
    created_at.strftime("%m/%d/%Y")
  end

  def orig_image_url
    image.url
  end

  def self.building_photos building_ids
    where(imageable_id: building_ids, imageable_type: 'Building')
  end

  def self.cached_building_photos building_ids
    key = building_ids.present? ? building_ids.join('_') : '1'
    Rails.cache.fetch([self, 'building_photos', key]) { building_photos(building_ids) }
  end

  def uploaded_img_url
    if self.image.exists?(:medium) #self.image.styles[:medium]
      self.image.url(:medium)
    else
      self.image.url(:original)
    end
  end

  def self.image_uploads_count object
    object.uploads.where('image_file_name is not null').count
  end

	def self.marker_image object
    no_image = 'no-photo.png'
    if object.uploads.present?
      if object.image_uploads.present?
        image_obj = object.image_uploads.first
        image_obj.image_file_name.present? ? image_obj.uploaded_img_url : no_image if image_obj.present?
      end
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

  def set_sort_index
    imageable = self.imageable
    #unit_ids = imageable.units.map(&:id)
    #uploads = Upload.where("imageable_id = ? or imageable_id in (?)", imageable.id, unit_ids).where.not(id: self.id)
    uploads = Upload.where(imageable_id: imageable.id, imageable_type: 'Building') #.where.not(id: self.id)
    uploads = uploads.order('sort ASC NULLS LAST, created_at ASC')
    uploads.each_with_index do |upload, index|
      upload.update(sort: index+1) 
    end
  end

  # def is_video?
  #   image.instance.attachment_content_type =~ %r(video)
  # end
end
