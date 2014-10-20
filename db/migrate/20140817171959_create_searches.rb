class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      
      t.string :name
      t.text :description
      t.references :user, index: true, null: false
      t.column :state, :integer, default: 0
      
      t.string :term
      t.string :scope
      
      t.timestamps
    end
  end
end
