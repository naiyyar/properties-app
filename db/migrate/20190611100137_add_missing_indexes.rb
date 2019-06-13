class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :authorizations, :user_id
    add_index :average_caches, :rater_id
    add_index :average_caches, [:rateable_id, :rateable_type]
    add_index :buildings, :management_company_id
    add_index :buildings, :user_id
    add_index :contacts, :building_id
    add_index :document_downloads, :upload_id
    add_index :document_downloads, :user_id
    add_index :favorites, :favorable_id
    add_index :favorites, :favoriter_id
    add_index :featured_buildings, :building_id
    add_index :featured_comp_buildings, :building_id
    add_index :featured_comp_buildings, :featured_comp_id
    add_index :featured_comps, :building_id
    add_index :overall_averages, [:rateable_id, :rateable_type]
    add_index :pg_search_documents, [:searchable_id, :searchable_type]
    add_index :rental_price_histories, :unit_id
    add_index :review_flags, :review_id
    add_index :review_flags, :user_id
    add_index :reviews, :user_id
    add_index :reviews, [:reviewable_id, :reviewable_type]
    add_index :roles, [:resource_id, :resource_type]
    add_index :subway_station_lines, :subway_station_id
    add_index :units, :building_id
    add_index :units, :user_id
    add_index :uploads, :user_id
    add_index :uploads, [:imageable_id, :imageable_type]
    add_index :useful_reviews, :review_id
    add_index :useful_reviews, :user_id
    add_index :users_roles, :role_id
    add_index :users_roles, :user_id
    add_index :users_roles, [:role_id, :user_id]
  end
end
