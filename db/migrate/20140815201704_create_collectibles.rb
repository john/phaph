class CreateCollectibles < ActiveRecord::Migration
  def change
    create_table :collectibles do |t|
      t.references :user, index: true, null: false
      t.references :document, index: true, null: false
      t.references :collection, index: true, null: false
      
      t.timestamps
    end
  end
end
