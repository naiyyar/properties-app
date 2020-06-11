class CreateFeaturedAgents < ActiveRecord::Migration[5.0]
  def change
    create_table :featured_agents do |t|
    	t.string :first_name
    	t.string :last_name
    	t.string :email
    	t.string :license_number
    	t.string :broker_firm
    	t.string :phone
    	t.string :webiste
    	t.string :neighborhood
      t.timestamps
    end
  end
end
