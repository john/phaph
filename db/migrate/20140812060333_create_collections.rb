class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :name
      t.text :description
      t.references :user, index: true, null: false
      t.references :organization, index: true
      t.string :state

      t.timestamps
    end
  end
end
