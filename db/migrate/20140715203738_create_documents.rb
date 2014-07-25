class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :name, index: true, null: false
      t.text :description
      t.string :source
      t.string :journal
      t.datetime :published_at
      t.string :principle_authors
      t.string :other_authors
      t.string :rights
      t.references :user, index: true, null: false
      t.references :lab, index: true
      t.references :grant, index: true
      t.integer :scope, null: false, default: Scope::PUBLIC
      t.string :state, null: false

      t.timestamps
    end
  end
end
