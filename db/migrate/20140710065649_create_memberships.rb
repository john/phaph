class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :user_id, null: false
      t.integer :belongable_id, null: false
      t.string :belongable_type, null: false
      t.integer :creator_id, null: false
      t.text :notes
      t.string :state, null: false

      t.timestamps
    end
    
    add_index :memberships, :user_id
    add_index :memberships, [:belongable_id, :belongable_type], :unique => true
    
  end
end
