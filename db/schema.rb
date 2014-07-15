# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140714224729) do

  create_table "categories", force: true do |t|
    t.string   "name",        null: false
    t.text     "description"
    t.integer  "creator_id",  null: false
    t.integer  "lab_id",      null: false
    t.integer  "grant_id",    null: false
    t.string   "state",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "costs", force: true do |t|
    t.string   "name",                                             null: false
    t.text     "description"
    t.decimal  "amount",      precision: 10, scale: 0, default: 0
    t.integer  "creator_id",                                       null: false
    t.integer  "user_id"
    t.integer  "lab_id",                                           null: false
    t.integer  "grant_id"
    t.integer  "category_id"
    t.integer  "periodicity"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "state",                                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grants", force: true do |t|
    t.string   "name",                                                           null: false
    t.text     "description"
    t.string   "source"
    t.string   "source_id"
    t.string   "principal_investigators"
    t.text     "investigators"
    t.string   "program_manager"
    t.string   "sponsor"
    t.string   "nsf_programs"
    t.string   "nsf_program_reference_code"
    t.string   "nsf_program_element_code"
    t.datetime "awarded_at"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.decimal  "amount",                                precision: 10, scale: 0
    t.float    "overhead",                   limit: 24
    t.integer  "creator_id",                                                     null: false
    t.integer  "user_id"
    t.integer  "lab_id",                                                         null: false
    t.string   "state",                                                          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "grants", ["lab_id"], name: "index_grants_on_lab_id", using: :btree
  add_index "grants", ["name"], name: "index_grants_on_name", using: :btree
  add_index "grants", ["user_id"], name: "index_grants_on_user_id", using: :btree

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "labs", force: true do |t|
    t.string   "name",        null: false
    t.text     "description"
    t.integer  "creator_id",  null: false
    t.string   "state",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "labs", ["name"], name: "index_labs_on_name", using: :btree

  create_table "memberships", force: true do |t|
    t.integer  "user_id",         null: false
    t.integer  "belongable_id",   null: false
    t.string   "belongable_type", null: false
    t.integer  "creator_id",      null: false
    t.text     "notes"
    t.string   "state",           null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["belongable_id", "belongable_type"], name: "index_memberships_on_belongable_id_and_belongable_type", unique: true, using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "samples", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "source"
    t.integer  "creator_id"
    t.integer  "lab_id"
    t.integer  "grant_id"
    t.string   "location"
    t.decimal  "latitude",        precision: 15, scale: 10
    t.decimal  "longitude",       precision: 15, scale: 10
    t.decimal  "collection_temp", precision: 10, scale: 0
    t.datetime "collected_at"
    t.datetime "prepped_at"
    t.datetime "analyzed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name",                   default: ""
    t.string   "email",                  default: "", null: false
    t.integer  "creator_id"
    t.string   "encrypted_password",     default: "", null: false
    t.text     "description"
    t.string   "state",                               null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
