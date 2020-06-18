class AddBillableTypeAndBillableIdToBillings < ActiveRecord::Migration[5.0]
  def change
    add_column :billings, :billable_type, :string
    add_column :billings, :billable_id, 	:integer
  end
end
