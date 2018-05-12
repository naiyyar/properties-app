class RenameResidentColumnsInReviews < ActiveRecord::Migration
  def change
  	rename_column :reviews, :last_year_at_residence, :resident_from
  	rename_column :reviews, :stay_time, :resident_to
  end
end
