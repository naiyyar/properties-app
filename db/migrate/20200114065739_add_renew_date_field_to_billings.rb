class AddRenewDateFieldToBillings < ActiveRecord::Migration[5.0]
  def change
    add_column :billings, :renew_date, :datetime
  end
end
