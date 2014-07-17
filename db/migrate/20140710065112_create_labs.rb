class CreateLabs < ActiveRecord::Migration
  def change
    create_table :labs do |t|
      t.string :name, null: false
      t.text :description
      t.string :email
      t.references :creator, index: true, null: false
      t.integer :scope, null: false, default: Scope::PUBLIC
      t.string :state, null: false

      t.timestamps
    end
    
    add_index :labs, :name
    
  end
end
