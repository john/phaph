class CreateLabs < ActiveRecord::Migration
  def change
    create_table :labs do |t|
      t.string :name
      t.text :description
      t.integer :user_id
      t.string :state

      t.timestamps
    end
    
    add_index :labs, :name
    
  end
end
