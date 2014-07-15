class CreateLabs < ActiveRecord::Migration
  def change
    create_table :labs do |t|
      t.string :name, null: false
      t.text :description
      t.string :email
      t.string :location
      t.decimal :latitude, :precision => 15, :scale => 10
      t.decimal :longitude, :precision => 15, :scale => 10
      t.integer :creator_id, null: false
      t.string :state, null: false

      t.timestamps
    end
    
    add_index :labs, :name
    
  end
end
