class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :name, default: ''
      t.string :username
      t.text :description

      t.string :email, null: false, default: ''
      t.string :encrypted_password, null: false, default: ""

      t.integer :creator_id
      t.string :encrypted_password, null: false, default: ''
      t.integer :scope, null: false, default: Scope::PUBLIC
      # t.string :state, null: false
      t.column :state, :integer, default: 0

      # t.recoverable
      # t.rememberable
      # t.trackablea
      # t.confirmable
      # # t.string   :unconfirmed_email # Only if using reconfirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      # Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      # Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      t.timestamps
    end

    add_index :users, :email,                unique: true
    add_index :users, :name #,                unique: true
    # add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
