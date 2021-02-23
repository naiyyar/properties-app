module ImageableConcern
	extend ActiveSupport::Concern
	
  included do
		has_many :uploads, as: :imageable, dependent: :destroy
		accepts_nested_attributes_for :uploads, :allow_destroy => true
	end

  def get_uploads
    uploads_hash = Hash.new
    assets       = self.uploads
    uploads_hash.merge!({ image_uploads: cached_image_uploads(assets), 
                         doc_uploads:   doc_uploads(assets) })
  end

	def image_uploads assets = nil
    return uploads.with_image.includes(:imageable) unless assets.present?
    assets.with_image.includes(:imageable)
  end

  def cached_image_uploads assets
    Rails.cache.fetch([self, 'imageUploads']) { image_uploads(assets) }
  end

  def doc_uploads assets
    assets.with_doc.to_a
  end
end