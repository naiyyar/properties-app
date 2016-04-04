class AddAttachmentPhotoToBuildings < ActiveRecord::Migration
  def self.up
    change_table :buildings do |t|
      t.attachment :photo
    end
  end

  def self.down
    remove_attachment :buildings, :photo
  end
end
