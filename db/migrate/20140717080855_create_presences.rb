class CreatePresences < ActiveRecord::Migration
  def change
    create_table :presences do |t|
      t.integer :location_id, index: true, null: false
      t.references :locatable, polymorphic: true, index: true, null: false
      t.column :state, :integer, default: 0

      t.timestamps
    end
    
  end
  
end
