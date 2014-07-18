class CreatePapers < ActiveRecord::Migration
  def change
    create_table :papers do |t|
      t.string :name, index: true
      t.text :description
      t.string :source
      t.string :journal
      t.datetime :published_at
      t.string :principle_authors
      t.string :other_authors
      t.string :rights
      t.references :creator, index: true, null: false
      t.references :lab, index: true, null: false
      t.references :grant, index: true
      t.integer :scope, null: false, default: Scope::PUBLIC
      t.string :state

      t.timestamps
    end
  end
end
