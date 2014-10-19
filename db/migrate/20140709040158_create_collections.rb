class CreateCollections < ActiveRecord::Migration
  
  def change
    create_table :collections do |t|
      t.string :name, index: true, null: false
      t.string :slug, index: true, unique: true, null: false
      t.text :description
      t.references :user, index: true, null: false
      t.integer :view_scope, null: false, default: Scope::PUBLIC
      t.integer :contribute_scope, null: false, default: Scope::PUBLIC
      t.integer :state, default: 0, null: false

      t.timestamps
    end
  end

end
