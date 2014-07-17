class CreatePresences < ActiveRecord::Migration
  def change
    create_table :presences do |t|
      t.integer :location_id, null: false
      t.references :locatable, polymorphic: true, index: true, null: false
      t.string :state, null: false

      t.timestamps
    end
    
    add_index :presences, :location_id
    # add_index :presences, [:locatable_id, :locatable_type], :unique => true
    
  end
  
end
