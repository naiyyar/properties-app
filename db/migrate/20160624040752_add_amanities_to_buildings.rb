class AddAmanitiesToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :elevator, :integer
    add_column :buildings, :garage, :boolean, default: false
    add_column :buildings, :gym, :boolean, default: false
    add_column :buildings, :live_in_super, :boolean, default: false
    add_column :buildings, :pets_allowed_cats, :boolean, default: false
    add_column :buildings, :pets_allowed_dogs, :boolean, default: false
    add_column :buildings, :roof_deck, :boolean, default: false
    add_column :buildings, :swimming_pool, :boolean, default: false
    add_column :buildings, :walk_up, :boolean, default: false
  end
  
end
