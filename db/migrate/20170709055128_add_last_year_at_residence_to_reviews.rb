class AddLastYearAtResidenceToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :last_year_at_residence, :string
  end
end
