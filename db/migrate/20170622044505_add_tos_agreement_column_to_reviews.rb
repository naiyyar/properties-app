class AddTosAgreementColumnToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :tos_agreement, :boolean, default: false
  end
end
