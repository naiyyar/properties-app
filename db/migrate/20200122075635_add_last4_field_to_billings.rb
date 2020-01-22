class AddLast4FieldToBillings < ActiveRecord::Migration[5.0]
  def change
    add_column :billings, :last4, :string
  end
end
