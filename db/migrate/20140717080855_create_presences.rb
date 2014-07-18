class CreatePresences < ActiveRecord::Migration
  def change
    create_table :presences do |t|
      t.integer :location_id, index: true, null: false
      t.references :locatable, polymorphic: true, index: true, null: false
      t.string :state, null: false

      t.timestamps
    end
    
  end
  
end
