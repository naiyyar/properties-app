class AddReviewableColumnsToReviews < ActiveRecord::Migration
  def change
    add_reference :reviews, :reviewable, polymorphic: true, index: true
  end
end
