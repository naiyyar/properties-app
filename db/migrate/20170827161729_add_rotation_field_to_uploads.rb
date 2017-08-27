class AddRotationFieldToUploads < ActiveRecord::Migration
  def self.up
  	add_column :uploads, :rotation, :integer, :null => false, :default => 0
  end

  def self.down
  	add_column :uploads, :rotation
  end
end
