class CreateAmenities < ActiveRecord::Migration
  def self.up
    create_table :amenities do |t|
      t.string :name
      t.references :amenitable, polymorphic: true, index: true
      t.integer :number_of_elevators
      t.timestamps null: false
    end
  end

  def self.down
  	drop_table :amenities
  end
end
