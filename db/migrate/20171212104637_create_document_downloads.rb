class CreateDocumentDownloads < ActiveRecord::Migration
  def change
    create_table :document_downloads do |t|
    	t.integer :upload_id
    	t.integer :user_id
      
      t.timestamps null: false
    end
  end
end
