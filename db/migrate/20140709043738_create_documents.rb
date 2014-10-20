class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :name, index: true, null: false
      t.string :slug, index: true, unique: true, null: false
      t.text :description
      t.string :url, :limit => 10000 # http://stackoverflow.com/questions/219569/best-database-field-type-for-a-url
      t.string :file
      t.string :file_location
      t.string :thumb_sm
      t.string :thumb_md
      t.string :thumb_lg
      t.string :source
      t.string :principle_authors
      t.string :other_authors
      t.string :rights
      t.references :user, index: true, null: false
      t.integer :scope, null: false, default: Scope::PUBLIC
      t.integer :state, default: 0, null: false

      t.datetime :published_at
      t.timestamps
    end
  end
end
