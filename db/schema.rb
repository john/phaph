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

ActiveRecord::Schema.define(version: 20140817171959) do

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

  create_table "collectibles", force: true do |t|
    t.integer  "user_id",       null: false
    t.integer  "document_id",   null: false
    t.integer  "collection_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collectibles", ["collection_id"], name: "index_collectibles_on_collection_id", using: :btree
  add_index "collectibles", ["document_id"], name: "index_collectibles_on_document_id", using: :btree
  add_index "collectibles", ["user_id"], name: "index_collectibles_on_user_id", using: :btree

  create_table "collections", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id",         null: false
    t.integer  "organization_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collections", ["organization_id"], name: "index_collections_on_organization_id", using: :btree
  add_index "collections", ["user_id"], name: "index_collections_on_user_id", using: :btree

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

  create_table "documents", force: true do |t|
    t.string   "name",                              null: false
    t.text     "description"
    t.text     "url"
    t.string   "source"
    t.datetime "published_at"
    t.string   "file_location"
    t.string   "principle_authors"
    t.string   "other_authors"
    t.string   "rights"
    t.integer  "user_id",                           null: false
    t.integer  "organization_id"
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

  add_index "documents", ["organization_id"], name: "index_documents_on_organization_id", using: :btree
  add_index "documents", ["user_id"], name: "index_documents_on_user_id", using: :btree

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

  create_table "organizations", force: true do |t|
    t.string   "name",                    null: false
    t.text     "description"
    t.string   "email"
    t.integer  "user_id",                 null: false
    t.integer  "scope",       default: 3, null: false
    t.string   "state",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "organizations", ["user_id"], name: "index_organizations_on_user_id", using: :btree

  create_table "presences", force: true do |t|
    t.integer  "location_id",    null: false
    t.integer  "locatable_id",   null: false
    t.string   "locatable_type", null: false
    t.string   "state",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "presences", ["locatable_id", "locatable_type"], name: "index_presences_on_locatable_id_and_locatable_type", using: :btree

  create_table "searches", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id",         null: false
    t.integer  "organization_id"
    t.string   "state"
    t.string   "term"
    t.string   "scope"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "searches", ["organization_id"], name: "index_searches_on_organization_id", using: :btree
  add_index "searches", ["user_id"], name: "index_searches_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                   default: ""
    t.string   "username"
    t.text     "description"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.integer  "creator_id"
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

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree

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
