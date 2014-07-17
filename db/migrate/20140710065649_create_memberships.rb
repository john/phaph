class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :user, index: true, null: false
      t.references :belongable, polymorphic: true, index: true, null: false
      t.references :creator, index: true, null: false
      t.text :notes
      t.integer :scope, null: false, default: Scope::PUBLIC
      t.string :state, null: false

      t.timestamps
    end
    
  end
end
