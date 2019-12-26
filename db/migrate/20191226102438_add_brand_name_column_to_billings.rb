class AddBrandNameColumnToBillings < ActiveRecord::Migration[5.0]
  def change
    add_column :billings, :brand, :string
  end
end
