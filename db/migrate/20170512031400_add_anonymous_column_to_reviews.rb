class AddAnonymousColumnToReviews < ActiveRecord::Migration
  def self.up
    add_column :reviews, :anonymous, :boolean, :default => false
  end

  def self.down
    remove_column :reviews, :anonymous
  end
end
