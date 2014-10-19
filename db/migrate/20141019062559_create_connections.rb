class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
      t.integer :user_id, index: true, null: false
      t.string :service, null: false
      t.text :followers
      t.text :following

      t.timestamps null: false
    end
  end
end
