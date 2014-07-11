class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.integer :user_id
      t.integer :belongable_id
      t.string :belongable_type
      t.text :notes
      t.string :state

      t.timestamps
    end
    
    add_index :memberships, :user_id
    add_index :memberships, [:belongable_id, :belongable_type], :unique => true
    
  end
end
