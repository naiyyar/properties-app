class RemoveUnusedFieldsFormBuildingsTable < ActiveRecord::Migration[5.0]
  def change
  	remove_column :buildings, :laundry_facility
    remove_column :buildings, :parking
    remove_column :buildings, :doorman
    remove_column :buildings, :garage
    remove_column :buildings, :gym
    remove_column :buildings, :live_in_super
    remove_column :buildings, :pets_allowed_cats
    remove_column :buildings, :pets_allowed_dogs
    remove_column :buildings, :roof_deck
    remove_column :buildings, :swimming_pool
    remove_column :buildings, :walk_up
    remove_column :buildings, :courtyard
    remove_column :buildings, :management_company_run
    remove_column :buildings, :childrens_playroom
  	remove_column :buildings, :no_fee
  	remove_column :buildings, :studio
    remove_column :buildings, :one_bed
    remove_column :buildings, :two_bed
    remove_column :buildings, :three_bed
    remove_column :buildings, :four_plus_bed
    remove_column :buildings, :co_living, :integer
		remove_column :buildings, :deposit_free, :boolean
  end
end
