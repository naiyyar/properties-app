class CreateNeighborhoodLinks < ActiveRecord::Migration
  def change
    create_table :neighborhood_links do |t|
    	t.string :neighborhood
    	t.date :date
    	t.string :title
    	t.text :web_url
    	t.string :source
    	
      t.timestamps null: false
    end
  end
end
