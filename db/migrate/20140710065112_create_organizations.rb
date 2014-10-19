class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name, index: true, null: false
      t.text :description
      t.string :email
      t.references :user, index: true, null: false
      t.integer :scope, null: false, default: Scope::PUBLIC
      t.integer :state, default: 0, null: false

      t.timestamps
    end
  end
end
