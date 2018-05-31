class AddFileUidFieldToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :file_uid, :string
  end
end
