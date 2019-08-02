class ChangeRentStabilizeColumnType < ActiveRecord::Migration[5.0]
  def change
  	change_column :listings, :rent_stabilize, :string, default: nil
  end
end
