class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :name, index: true, null: false
      t.string :slug, index: true, unique: true, null: false
      t.text :description
      t.text :url
      t.string :file
      t.string :file_location
      t.string :thumb_sm
      t.string :thumb_md
      t.string :thumb_lg
      t.string :source
      # t.string :file_path
      t.string :principle_authors
      t.string :other_authors
      t.string :rights
      t.references :user, index: true, null: false
      t.references :organization, index: true
      t.integer :scope, null: false, default: Scope::PUBLIC
      t.column :state, :integer, default: 0, null: false

      # t.string :service
      # t.string :service_id
      # t.integer :service_revision
      # t.string :service_root
      # t.string :service_path
      # t.datetime :service_modified_at
      # t.integer :service_size_in_bytes
      # t.string :service_mime_type

      t.datetime :published_at
      t.timestamps
    end
  end
end
