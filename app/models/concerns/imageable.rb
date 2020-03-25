module Imageable
	extend ActiveSupport::Concern
	included do
		has_many :uploads, as: :imageable
		accepts_nested_attributes_for :uploads, :allow_destroy => true
	end

	def image_uploads
    uploads.where.not(image_file_name: nil).includes(:imageable)
  end

  def chached_image_uploads
    Rails.cache.fetch([self, 'image_uploads']) { image_uploads.to_a }
  end

  def doc_uploads
    uploads.where.not(document_file_name: nil).to_a
  end
end