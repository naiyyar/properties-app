class CreateGcoordinates < ActiveRecord::Migration
  def change
    create_table :gcoordinates do |t|
    	t.float :latitude
			t.float :longitude
			t.string :zipcode
			t.string :state
			t.string :city
      
      t.timestamps null: false
    end
  end
end
