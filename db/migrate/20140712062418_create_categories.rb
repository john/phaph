class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.text :description
      t.integer :creator_id, null: false
      t.integer :lab_id, null: false
      t.integer :grant_id, null: false
      t.string :state, null: false

      t.timestamps
    end
  end
end
