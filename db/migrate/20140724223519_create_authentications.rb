# http://labs.thredup.com/integrating-your-rails-app-with-dropbox


class CreateAuthentications < ActiveRecord::Migration
  def change
    
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret
      t.boolean :authorized
      t.string :account_email
      t.datetime :token_expires_at
      t.text :serialized_session
      # t.string :state, null: false
      t.column :state, :integer, default: 0

      t.timestamps
    end
    add_index :authentications, :account_email
    add_index :authentications, :authorized
    
  end
end
