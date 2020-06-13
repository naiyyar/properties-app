class CreateFeaturedAgents < ActiveRecord::Migration[5.0]
  def change
    create_table :featured_agents do |t|
    	t.string :first_name
    	t.string :last_name
    	t.string :email
    	t.string :license_number
    	t.string :broker_firm
    	t.string :phone
    	t.string :website
    	t.string :neighborhood
      t.integer :user_id
      t.datetime :start_date
      t.datetime :end_date
      t.string :featured_by
      t.integer :uploads_count
      t.boolean :active, default: false
      t.boolean :renew,  default: false
      t.timestamps
    end
  end
end
