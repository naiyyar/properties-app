class AddDocumentAttachmentFieldToUploads < ActiveRecord::Migration
  def change
  	add_attachment :uploads, :document
  end
end
