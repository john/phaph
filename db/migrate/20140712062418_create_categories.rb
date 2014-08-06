class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, index: true, null: false
      t.text :description
      t.references :user, index: true, null: false
      t.references :organization, index: true, null: false
      t.references :grant, index: true
      t.integer :scope, null: false, default: Scope::PUBLIC
      t.string :state, null: false

      t.timestamps
    end
  end
end
