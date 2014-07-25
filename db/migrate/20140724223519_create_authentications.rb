class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret
      t.datetime :token_expires_at
      t.string :state, null: false

      t.timestamps
    end
  end
end
