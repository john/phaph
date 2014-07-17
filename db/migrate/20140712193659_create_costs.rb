class CreateCosts < ActiveRecord::Migration
  def change
    create_table :costs do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :amount
      t.references :creator, index: true, null: false
      t.references :user, index: true, null: false
      t.references :lab, index: true, null: false
      t.references :grant, index: true, null: false
      # t.references :category, index: true, null: false
      t.integer :periodicity, null: false
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :scope, null: false, default: Scope::LAB
      t.string :state, null: false

      t.timestamps
    end
  end
end
