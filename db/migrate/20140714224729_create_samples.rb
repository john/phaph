class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      # t.string :guid
      t.string :name, index: true
      t.text :description
      t.string :source
      t.references :creator, index: true, null: false
      t.references :lab, index: true, null: false
      t.references :grant, index: true
      
      t.string :location
      t.decimal :latitude, :precision => 15, :scale => 10
      t.decimal :longitude, :precision => 15, :scale => 10
      
      t.decimal :collection_temp
      t.datetime :collected_at
      t.datetime :prepped_at
      t.datetime :analyzed_at
      t.integer :scope, null: false, default: Scope::LAB
      t.string :state, null: false
      
      t.timestamps
    end
  end
end
