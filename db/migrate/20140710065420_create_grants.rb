class CreateGrants < ActiveRecord::Migration
  def change
    create_table :grants do |t|
      t.string :name
      t.text :description
      t.string :source
      t.decimal :amount
      t.float :overhead
      t.integer :user_id
      t.integer :lab_id
      t.string :state

      t.timestamps
    end
    
    add_index :grants, :user_id
    add_index :grants, :lab_id
    
  end
end
