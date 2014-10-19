class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name, index: true, null: false
      t.decimal :latitude, :precision => 15, :scale => 10
      t.decimal :longitude, :precision => 15, :scale => 10
      t.string :city
      t.string :state
      t.string :country
      
      t.timestamps
    end

  end
end
