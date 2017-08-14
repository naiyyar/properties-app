class AddSortColumnToUploads < ActiveRecord::Migration
  def change
    add_column :uploads, :sort, :integer
  end
end
