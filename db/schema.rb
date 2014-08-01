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

ActiveRecord::Schema.define(version: 20140724223519) do

  create_table "authentications", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.boolean  "authorized"
    t.string   "account_email"
    t.datetime "token_expires_at"
    t.text     "serialized_session"
    t.string   "state",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["account_email"], name: "index_authentications_on_account_email", using: :btree
  add_index "authentications", ["authorized"], name: "index_authentications_on_authorized", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name",                    null: false
    t.text     "description"
    t.integer  "user_id",                 null: false
    t.integer  "lab_id",                  null: false
    t.integer  "grant_id"
    t.integer  "scope",       default: 3, null: false
    t.string   "state",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["grant_id"], name: "index_categories_on_grant_id", using: :btree
  add_index "categories", ["lab_id"], name: "index_categories_on_lab_id", using: :btree
  add_index "categories", ["user_id"], name: "index_categories_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "commentable_id",   default: 0
    t.string   "commentable_type"
    t.string   "title"
    t.text     "body"
    t.string   "subject"
    t.integer  "user_id",          default: 0, null: false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.string   "state",                        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "costs", force: true do |t|
    t.string   "name",                                             null: false
    t.text     "description"
    t.decimal  "amount",      precision: 10, scale: 0
    t.integer  "creator_id",                                       null: false
    t.integer  "user_id",                                          null: false
    t.integer  "lab_id",                                           null: false
    t.integer  "grant_id"
    t.integer  "category_id"
    t.integer  "periodicity",                                      null: false
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.integer  "scope",                                default: 2, null: false
    t.string   "state",                                            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "costs", ["category_id"], name: "index_costs_on_category_id", using: :btree
  add_index "costs", ["creator_id"], name: "index_costs_on_creator_id", using: :btree
  add_index "costs", ["grant_id"], name: "index_costs_on_grant_id", using: :btree
  add_index "costs", ["lab_id"], name: "index_costs_on_lab_id", using: :btree
  add_index "costs", ["user_id"], name: "index_costs_on_user_id", using: :btree

  create_table "documents", force: true do |t|
    t.string   "name",                              null: false
    t.text     "description"
    t.string   "source"
    t.string   "journal"
    t.datetime "published_at"
    t.string   "principle_authors"
    t.string   "other_authors"
    t.string   "rights"
    t.integer  "user_id",                           null: false
    t.integer  "lab_id"
    t.integer  "grant_id"
    t.integer  "scope",                 default: 3, null: false
    t.string   "service"
    t.string   "service_id"
    t.integer  "service_revision"
    t.string   "service_root"
    t.string   "service_path"
    t.datetime "service_modified_at"
    t.integer  "service_size_in_bytes"
    t.string   "service_mime_type"
    t.string   "state",                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file"
  end

  add_index "documents", ["grant_id"], name: "index_documents_on_grant_id", using: :btree
  add_index "documents", ["lab_id"], name: "index_documents_on_lab_id", using: :btree
  add_index "documents", ["user_id"], name: "index_documents_on_user_id", using: :btree

  create_table "grants", force: true do |t|
    t.string   "name",                                                                       null: false
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
    t.integer  "user_id",                                                                    null: false
    t.integer  "lab_id",                                                                     null: false
    t.integer  "scope",                                                          default: 3, null: false
    t.string   "state",                                                                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "grants", ["lab_id"], name: "index_grants_on_lab_id", using: :btree
  add_index "grants", ["user_id"], name: "index_grants_on_user_id", using: :btree

  create_table "labs", force: true do |t|
    t.string   "name",                    null: false
    t.text     "description"
    t.string   "email"
    t.integer  "user_id",                 null: false
    t.integer  "scope",       default: 3, null: false
    t.string   "state",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "labs", ["user_id"], name: "index_labs_on_user_id", using: :btree

  create_table "locations", force: true do |t|
    t.string   "name",                                     null: false
    t.decimal  "latitude",       precision: 15, scale: 10
    t.decimal  "longitude",      precision: 15, scale: 10
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "locatable_id"
    t.integer  "locatable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["locatable_id", "locatable_type"], name: "index_locations_on_locatable_id_and_locatable_type", unique: true, using: :btree

  create_table "memberships", force: true do |t|
    t.integer  "user_id",                     null: false
    t.integer  "belongable_id",               null: false
    t.string   "belongable_type",             null: false
    t.integer  "creator_id",                  null: false
    t.text     "notes"
    t.integer  "scope",           default: 3, null: false
    t.string   "state",                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["belongable_id", "belongable_type"], name: "index_memberships_on_belongable_id_and_belongable_type", using: :btree
  add_index "memberships", ["creator_id"], name: "index_memberships_on_creator_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "presences", force: true do |t|
    t.integer  "location_id",    null: false
    t.integer  "locatable_id",   null: false
    t.string   "locatable_type", null: false
    t.string   "state",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "presences", ["locatable_id", "locatable_type"], name: "index_presences_on_locatable_id_and_locatable_type", using: :btree

  create_table "samples", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "source"
    t.integer  "user_id",                                               null: false
    t.integer  "lab_id",                                                null: false
    t.integer  "grant_id"
    t.string   "location"
    t.decimal  "latitude",        precision: 15, scale: 10
    t.decimal  "longitude",       precision: 15, scale: 10
    t.decimal  "collection_temp", precision: 10, scale: 0
    t.datetime "collected_at"
    t.datetime "prepped_at"
    t.datetime "analyzed_at"
    t.integer  "scope",                                     default: 2, null: false
    t.string   "state",                                                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "samples", ["grant_id"], name: "index_samples_on_grant_id", using: :btree
  add_index "samples", ["lab_id"], name: "index_samples_on_lab_id", using: :btree
  add_index "samples", ["user_id"], name: "index_samples_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                   default: ""
    t.text     "description"
    t.string   "email",                  default: "", null: false
    t.integer  "creator_id"
    t.string   "encrypted_password",     default: "", null: false
    t.integer  "scope",                  default: 3,  null: false
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
  add_index "users", ["name"], name: "index_users_on_name", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

end
