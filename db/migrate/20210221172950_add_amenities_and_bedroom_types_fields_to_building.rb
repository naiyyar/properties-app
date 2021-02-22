class AddAmenitiesAndBedroomTypesFieldsToBuilding < ActiveRecord::Migration[5.0]
  def change
    add_column :buildings, :amenities, :jsonb, default: {}
    add_column :buildings, :bedroom_types, :string, array: true, default: []
    
    add_index :buildings, :amenities, using: :gin
		add_index :buildings, :bedroom_types, using: :gin
  end
end
