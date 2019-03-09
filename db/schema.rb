# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190309153247) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"
  enable_extension "unaccent"

  create_table "authorizations", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.string   "token"
    t.string   "secret"
    t.string   "name"
    t.string   "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "average_caches", force: :cascade do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "avg",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "buildings", force: :cascade do |t|
    t.string   "building_name"
    t.string   "building_street_address"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address2"
    t.string   "zipcode"
    t.string   "webaddress"
    t.string   "city"
    t.string   "phone"
    t.string   "state"
    t.boolean  "laundry_facility"
    t.boolean  "parking"
    t.boolean  "doorman"
    t.text     "description"
    t.integer  "elevator"
    t.boolean  "garage",                  default: false
    t.boolean  "gym",                     default: false
    t.boolean  "live_in_super",           default: false
    t.boolean  "pets_allowed_cats",       default: false
    t.boolean  "pets_allowed_dogs",       default: false
    t.boolean  "roof_deck",               default: false
    t.boolean  "swimming_pool",           default: false
    t.boolean  "walk_up",                 default: false
    t.string   "neighborhood"
    t.string   "neighborhoods_parent"
    t.integer  "user_id"
    t.integer  "floors"
    t.integer  "built_in"
    t.integer  "number_of_units"
    t.boolean  "courtyard",               default: false
    t.boolean  "management_company_run",  default: false
    t.string   "neighborhood3"
    t.string   "web_url"
    t.string   "building_type"
    t.boolean  "childrens_playroom",      default: false
    t.boolean  "no_fee",                  default: false
    t.integer  "reviews_count"
    t.integer  "management_company_id"
    t.integer  "studio"
    t.integer  "one_bed"
    t.integer  "two_bed"
    t.integer  "three_bed"
    t.integer  "four_plus_bed"
    t.integer  "price"
  end

  add_index "buildings", ["building_name"], name: "index_buildings_on_building_name", using: :btree
  add_index "buildings", ["building_street_address"], name: "index_buildings_on_building_street_address", using: :btree
  add_index "buildings", ["city"], name: "index_buildings_on_city", using: :btree
  add_index "buildings", ["neighborhood"], name: "index_buildings_on_neighborhood", using: :btree
  add_index "buildings", ["neighborhood3"], name: "index_buildings_on_neighborhood3", using: :btree
  add_index "buildings", ["neighborhoods_parent"], name: "index_buildings_on_neighborhoods_parent", using: :btree
  add_index "buildings", ["zipcode"], name: "index_buildings_on_zipcode", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.text     "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "document_downloads", force: :cascade do |t|
    t.integer  "upload_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favorites", force: :cascade do |t|
    t.integer  "favorable_id"
    t.string   "favorable_type"
    t.integer  "favoriter_id"
    t.string   "favoriter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["favorable_id", "favorable_type"], name: "index_favorites_on_favorable_id_and_favorable_type", using: :btree
  add_index "favorites", ["favoriter_id", "favoriter_type"], name: "index_favorites_on_favoriter_id_and_favoriter_type", using: :btree

  create_table "featured_buildings", force: :cascade do |t|
    t.integer  "building_id",                 null: false
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "active",      default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "featured_comp_buildings", force: :cascade do |t|
    t.integer  "building_id"
    t.integer  "featured_comp_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "featured_comp_buildings", ["building_id", "featured_comp_id"], name: "f_comp_buildings", using: :btree

  create_table "featured_comps", force: :cascade do |t|
    t.integer  "building_id",                 null: false
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "active",      default: false
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "featured_comps", ["active"], name: "index_featured_comps_on_active", using: :btree
  add_index "featured_comps", ["start_date", "end_date"], name: "index_featured_comps_on_start_date_and_end_date", using: :btree

  create_table "gcoordinates", force: :cascade do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.string   "zipcode"
    t.string   "state"
    t.string   "city"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "neighborhood"
  end

  create_table "management_companies", force: :cascade do |t|
    t.string   "name"
    t.string   "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "neighborhood_links", force: :cascade do |t|
    t.string   "neighborhood"
    t.date     "date"
    t.string   "title"
    t.text     "web_url"
    t.string   "source"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "parent_neighborhood"
  end

  create_table "neighborhoods", force: :cascade do |t|
    t.string   "name"
    t.string   "boroughs"
    t.integer  "buildings_count"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "overall_averages", force: :cascade do |t|
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "overall_avg",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "pg_search_documents", ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree

  create_table "prices", force: :cascade do |t|
    t.decimal  "min_price"
    t.decimal  "max_price"
    t.integer  "bed_type"
    t.integer  "range"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rates", force: :cascade do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "stars",         null: false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "review_id"
  end

  add_index "rates", ["rateable_id", "rateable_type"], name: "index_rates_on_rateable_id_and_rateable_type", using: :btree
  add_index "rates", ["rater_id"], name: "index_rates_on_rater_id", using: :btree

  create_table "rating_caches", force: :cascade do |t|
    t.integer  "cacheable_id"
    t.string   "cacheable_type"
    t.float    "avg",            null: false
    t.integer  "qty",            null: false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rating_caches", ["cacheable_id", "cacheable_type"], name: "index_rating_caches_on_cacheable_id_and_cacheable_type", using: :btree

  create_table "rental_price_histories", force: :cascade do |t|
    t.date     "residence_start_date"
    t.date     "residence_end_date"
    t.decimal  "monthly_rent",         default: 0.0
    t.decimal  "broker_fee",           default: 0.0
    t.decimal  "non_refundable_costs", default: 0.0
    t.decimal  "rent_upfront",         default: 0.0
    t.decimal  "refundable_deposits",  default: 0.0
    t.integer  "unit_id"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "start_year"
    t.string   "end_year"
  end

  create_table "review_flags", force: :cascade do |t|
    t.integer  "review_id"
    t.integer  "user_id"
    t.text     "flag_description"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.string   "review_title"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "building_id"
    t.integer  "user_id"
    t.integer  "reviewable_id"
    t.string   "reviewable_type"
    t.string   "building_address"
    t.string   "tenant_status"
    t.string   "resident_to"
    t.string   "pros"
    t.string   "cons"
    t.string   "other_advice"
    t.boolean  "anonymous",        default: false
    t.boolean  "tos_agreement",    default: false
    t.string   "resident_from"
    t.boolean  "scraped",          default: false
  end

  add_index "reviews", ["reviewable_type", "reviewable_id"], name: "index_reviews_on_reviewable_type_and_reviewable_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "subway_station_lines", force: :cascade do |t|
    t.integer  "subway_station_id"
    t.string   "line"
    t.string   "color"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "subway_stations", force: :cascade do |t|
    t.string   "name"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "units", force: :cascade do |t|
    t.integer  "building_id"
    t.string   "name"
    t.text     "pros"
    t.text     "cons"
    t.integer  "number_of_bedrooms"
    t.decimal  "number_of_bathrooms",     default: 0.0
    t.decimal  "monthly_rent",            default: 0.0
    t.decimal  "square_feet",             default: 0.0
    t.decimal  "total_upfront_cost",      default: 0.0
    t.date     "rent_start_date"
    t.date     "rent_end_date"
    t.decimal  "security_deposit",        default: 0.0
    t.decimal  "broker_fee",              default: 0.0
    t.decimal  "move_in_fee",             default: 0.0
    t.decimal  "rent_upfront_cost",       default: 0.0
    t.decimal  "processing_fee",          default: 0.0
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "balcony",                 default: false
    t.boolean  "board_approval_required", default: false
    t.boolean  "converted_unit",          default: false
    t.boolean  "courtyard",               default: false
    t.boolean  "dishwasher",              default: false
    t.boolean  "fireplace",               default: false
    t.boolean  "furnished",               default: false
    t.boolean  "guarantors_accepted",     default: false
    t.boolean  "loft",                    default: false
    t.boolean  "management_company_run",  default: false
    t.boolean  "rent_controlled",         default: false
    t.boolean  "private_landlord",        default: false
    t.boolean  "storage_available",       default: false
    t.boolean  "sublet",                  default: false
    t.boolean  "terrace",                 default: false
    t.boolean  "can_be_converted",        default: false
    t.boolean  "dryer_in_unit",           default: false
    t.integer  "user_id"
  end

  create_table "uploads", force: :cascade do |t|
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "user_id"
    t.integer  "sort"
    t.integer  "rotation",              default: 0, null: false
    t.string   "document_file_name"
    t.string   "document_content_type"
    t.integer  "document_file_size"
    t.datetime "document_updated_at"
    t.string   "file_uid"
  end

  create_table "useful_reviews", force: :cascade do |t|
    t.integer  "review_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.string   "image_url"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "phone"
    t.text     "about_me"
    t.string   "mobile"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "votes", force: :cascade do |t|
    t.boolean  "vote",          default: false, null: false
    t.integer  "voteable_id",                   null: false
    t.string   "voteable_type",                 null: false
    t.integer  "voter_id"
    t.string   "voter_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "review_id"
  end

  add_index "votes", ["voteable_id", "voteable_type"], name: "index_votes_on_voteable_id_and_voteable_type", using: :btree
  add_index "votes", ["voter_id", "voter_type"], name: "index_votes_on_voter_id_and_voter_type", using: :btree

end
