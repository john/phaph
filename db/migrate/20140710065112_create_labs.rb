class CreateLabs < ActiveRecord::Migration
  def change
    create_table :labs do |t|
      t.string :name, null: false
      t.text :description
      t.integer :creator_id, null: false
      t.string :state, null: false

      t.timestamps
    end
    
    add_index :labs, :name
    
  end
end
