class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.text :description
      t.references :creator, index: true, null: false
      t.references :lab, index: true, null: false
      t.references :grant, index: true, null: false
      t.integer :scope, null: false, default: Scope::PUBLIC
      t.string :state, null: false

      t.timestamps
    end
  end
end
