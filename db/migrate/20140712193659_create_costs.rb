class CreateCosts < ActiveRecord::Migration
  def change
    create_table :costs do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :amount
      t.integer :creator_id, null: false
      t.integer :user_id
      t.integer :lab_id, null: false
      t.integer :grant_id
      t.integer :category_id
      t.integer :periodicity, null: false
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :state, null: false

      t.timestamps
    end
  end
end
