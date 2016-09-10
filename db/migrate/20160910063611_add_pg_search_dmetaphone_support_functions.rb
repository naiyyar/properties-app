class AddPgSearchDmetaphoneSupportFunctions < ActiveRecord::Migration
  def self.up
    execute 'CREATE EXTENSION pg_trgm;'
    execute 'CREATE EXTENSION fuzzystrmatch;'
  end
end
