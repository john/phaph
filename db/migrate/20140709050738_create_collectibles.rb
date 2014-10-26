class CreateCollectibles < ActiveRecord::Migration
  def change
    create_table :collectibles do |t|
      t.string :name, index: true, null: false, default: 'collectible'
      t.text :description
      t.integer :scope, null: false, default: Scope::PUBLIC
      t.integer :state, default: 0, null: false
      t.integer :collected_from_id, index: true
      t.references :user, index: true, null: false
      t.references :document, index: true, null: false
      t.references :collection, index: true, null: false
      
      t.timestamps
    end
  end
end
