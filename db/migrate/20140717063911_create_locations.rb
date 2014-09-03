class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name, index: true, null: false
      t.decimal :latitude, :precision => 15, :scale => 10
      t.decimal :longitude, :precision => 15, :scale => 10
      t.string :city
      # t.string :state
      t.column :state, :integer, default: 0
      t.string :country
      t.integer :locatable_id
      t.integer :locatable_type
      
      t.timestamps
    end
    
    add_index :locations, [:locatable_id, :locatable_type], :unique => true
    
  end
end
