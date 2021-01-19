module ImageableConcern
	extend ActiveSupport::Concern
	included do
		has_many :uploads, as: :imageable, dependent: :destroy
		accepts_nested_attributes_for :uploads, :allow_destroy => true
	end

  def get_uploads
    uploads_hash = Hash.new
    assets       = self.uploads.all
    uploads_hash.merge!({ image_uploads: chached_image_uploads(assets), 
                         doc_uploads:   doc_uploads(assets) })
  end

	def image_uploads assets = nil
    return uploads.with_image unless assets.present?
    assets.with_image
  end

  def chached_image_uploads assets
    Rails.cache.fetch([self, 'image_uploads']) { image_uploads(assets).to_a }
  end

  def doc_uploads assets
    assets.with_doc.to_a
  end
end