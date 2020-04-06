class AddCoLivingAndDepositFreeToBuildings < ActiveRecord::Migration[5.0]
  def change
  	add_column :buildings, :co_living, :integer
  	add_column :buildings, :deposit_free, :boolean
  	add_column :buildings, :deposit_free_company, :string
  end
end
