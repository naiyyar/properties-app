class AddReceiptNumberToBillings < ActiveRecord::Migration[5.0]
  def change
    add_column :billings, :receipt_number, :string
  end
end
