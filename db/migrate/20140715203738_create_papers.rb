class CreatePapers < ActiveRecord::Migration
  def change
    create_table :papers do |t|
      t.string :name
      t.text :description
      t.string :source
      t.string :journal
      t.datetime :published_at
      t.string :principle_authors
      t.string :other_authors
      t.string :rights
      t.integer :creator_id
      t.integer :lab_id
      t.integer :grant_id
      t.string :state

      t.timestamps
    end
  end
end
