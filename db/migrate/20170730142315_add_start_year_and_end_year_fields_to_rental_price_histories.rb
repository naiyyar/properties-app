class AddStartYearAndEndYearFieldsToRentalPriceHistories < ActiveRecord::Migration
  def change
  	add_column :rental_price_histories, :start_year, :string
		add_column :rental_price_histories, :end_year, :string
  end
end
