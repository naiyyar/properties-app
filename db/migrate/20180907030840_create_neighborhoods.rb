class CreateNeighborhoods < ActiveRecord::Migration
  def self.up
    create_table :neighborhoods do |t|
      t.string :name
      t.string :boroughs
      t.integer :buildings_count

      t.timestamps null: false
    end
  end

  def self.down
  	drop_table :neighborhoods
  end
end
