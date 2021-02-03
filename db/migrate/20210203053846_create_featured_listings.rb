class CreateFeaturedListings < ActiveRecord::Migration[5.0]
  def change
    create_table :featured_listings do |t|
    	#Contacts fields
    	t.string :first_name, index: true
    	t.string :last_name, 	index: true
    	t.string :email
    	t.string :phone

    	#locations fields
    	t.string :neighborhood, index: true
    	t.string :address, 			index: true
    	t.string :unit
    	t.string :city
    	t.string :state, default: 'NY'
    	t.string :zipcode

    	# Information fields
    	t.integer :rent
    	t.integer :bed
    	t.decimal :bath
    	t.integer :size
    	t.string  :apartment_type
    	t.date    :date_available
    	t.text    :description

    	t.integer :user_id, null: false, foreign_key: true, index: true
      t.datetime :start_date
      t.datetime :end_date
      t.string :featured_by
      t.integer :uploads_count, null: false, default: 0
      t.boolean :active, default: false
      t.boolean :renew,  default: false

      t.json :amenities, default: {no_fee: 'No Fee'}, null: false
      t.timestamps
    end
  end
end
