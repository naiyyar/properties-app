class Upload < ApplicationRecord
  resourcify
  
  IMG_CONTENT_TYPES = ['image/jpeg', 'image/gif', 'image/png']
	attr_accessor :rotation_degrees, :rotate
	
  # associations
  belongs_to :imageable, polymorphic: true
  has_many :document_downloads
  belongs_to :user

  # validations
  has_attached_file :image, 
                    :styles => { :small => '200x200', :original => '900x800', :medium => '550x450' },
                    :default_url => "/images/:style/missing.png",
                    #:convert_options => {:medium => '-quality 80 -strip' },
                    processors: [:rotator]
  
  validates_attachment :image,
                        :content_type => { :content_type => IMG_CONTENT_TYPES }
  
  has_attached_file :document
  validates_attachment  :document, 
                        :content_type => { :content_type => ['application/pdf','application/vnd.ms-excel',     
                                                             'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                                                             'application/msword', 
                                                             'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 
                                                             'text/plain'] 
                                          }
  
  # scopes
  default_scope { order('sort asc') }
  scope :with_image, -> { where.not(image_file_name: nil).includes(:imageable) }
  scope :with_doc,   -> { where.not(document_file_name: nil) }

  # callbacks
  after_create :set_sort_index
  after_save :update_counter_cache
  after_destroy :update_counter_cache

  # Methods

  def date_uploaded
    created_at.strftime("%m/%d/%Y")
  end

  def orig_image_url
    image.url
  end

  def small_img
    image.url(:small)
  end

  def uploaded_img_url style = :medium
    image.url(style)
    #!Warning: Exists checking taking too much time
    # if self.image.exists?(:medium)
    #   self.image.url(:medium)
    # else
    #   self.image.url(:original)
    # end
  end

  def slider_thumb_image style = :medium
    uploaded_img_url(style)
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

  def has_image?
    self.image_file_name != nil
  end

  # class Methods
  ##################################

  def self.building_photos building_ids
    where(imageable_id: building_ids, imageable_type: 'Building')
  end

  def self.cached_building_photos building_ids
    key = building_ids.present? ? building_ids.join('_') : '1'
    Rails.cache.fetch([self, 'building_photos', key]) { building_photos(building_ids) }
  end

  def self.uploads_json_hash(uploads)
    uploads.as_json(:methods => [:date_uploaded, :orig_image_url])
  end
  
  def self.image_uploads_count object
    object.uploads.where('image_file_name is not null').count
  end

	def self.marker_image object
    no_image = 'no-photo.jpg'
    uploads  = object.image_uploads
    return no_image if uploads.blank?
    image_obj = uploads.first
    if image_obj.present?
      image_obj.image_file_name.present? ? image_obj.uploaded_img_url : no_image
    end
	end

  private
  
  def set_defaults
    self.rotation ||= 0
  end

  def set_sort_index
    uploads = Upload.where(imageable_id: self.imageable.id, imageable_type: 'Building')
                    .includes(:imageable).order('sort ASC NULLS LAST, created_at ASC')
    uploads.each_with_index do |upload, index|
      upload.update_column('sort', index+1) 
    end
  end

  def update_counter_cache
    begin
      self.imageable.update_column('uploads_count', uploads_count)
    rescue Exception => e
      puts "SQL error in #{ __method__ }"
      ActiveRecord::Base.connection.execute 'ROLLBACK'

      raise e
    end
  end

  def uploads_count
    Upload.where('image_file_name is not null AND 
                  imageable_id = ? AND 
                  imageable_type = ?', imageable.id, imageable.class.name).size
  end

  # def is_video?
  #   image.instance.attachment_content_type =~ %r(video)
  # end
end
