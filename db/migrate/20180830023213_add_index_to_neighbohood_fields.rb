class AddIndexToNeighbohoodFields < ActiveRecord::Migration
  def change
  	add_index :buildings, :neighborhood
		add_index :buildings, :neighborhoods_parent
		add_index :buildings, :neighborhood3
  end
end
