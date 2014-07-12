class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description
      t.integer :creator_id
      t.integer :lab_id
      t.integer :grant_id
      t.string :state, null: false

      t.timestamps
    end
  end
end
