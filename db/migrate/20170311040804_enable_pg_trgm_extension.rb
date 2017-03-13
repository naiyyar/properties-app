class EnablePgTrgmExtension < ActiveRecord::Migration
  def change
  	enable_extension :pg_trgm
  end
end
