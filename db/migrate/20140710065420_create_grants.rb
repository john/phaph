class CreateGrants < ActiveRecord::Migration
  def change
    create_table :grants do |t|
      t.string :name, null: false
      t.text :description
      t.string :source
      t.string :source_id
      t.string :principal_investigators
      t.text :investigators
      t.string :program_manager
      t.string :sponsor
      t.string :nsf_programs
      t.string :nsf_program_reference_code #int or string?
      t.string :nsf_program_element_code
      t.datetime :awarded_at
      t.datetime :starts_at
      t.datetime :expires_at
      t.decimal :amount
      t.float :overhead
      t.integer :creator_id, null: false
      t.integer :user_id
      t.integer :lab_id, null: false
      
      t.string :state

      t.timestamps
    end
    
    add_index :grants, :name
    add_index :grants, :user_id
    add_index :grants, :lab_id
    
  end
end
