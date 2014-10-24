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

ActiveRecord::Schema.define(version: 20141019062559) do

  create_table "activities", force: true do |t|
    t.integer  "trackable_id",   limit: 4
    t.string   "trackable_type", limit: 255
    t.integer  "owner_id",       limit: 4
    t.string   "owner_type",     limit: 255
    t.string   "key",            limit: 255
    t.text     "parameters",     limit: 65535
    t.integer  "recipient_id",   limit: 4
    t.string   "recipient_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "authentications", force: true do |t|
    t.integer  "user_id",            limit: 4
    t.string   "provider",           limit: 255
    t.string   "uid",                limit: 255
    t.string   "token",              limit: 255
    t.string   "secret",             limit: 255
    t.boolean  "authorized",         limit: 1
    t.string   "account_email",      limit: 255
    t.datetime "token_expires_at"
    t.text     "serialized_session", limit: 65535
    t.integer  "state",              limit: 4,     default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["account_email"], name: "index_authentications_on_account_email", using: :btree
  add_index "authentications", ["authorized"], name: "index_authentications_on_authorized", using: :btree

  create_table "collectibles", force: true do |t|
    t.string   "name",          limit: 255,   default: "collectible", null: false
    t.text     "description",   limit: 65535
    t.integer  "scope",         limit: 4,     default: 3,             null: false
    t.integer  "state",         limit: 4,     default: 0,             null: false
    t.integer  "user_id",       limit: 4,                             null: false
    t.integer  "document_id",   limit: 4,                             null: false
    t.integer  "collection_id", limit: 4,                             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collectibles", ["collection_id"], name: "index_collectibles_on_collection_id", using: :btree
  add_index "collectibles", ["document_id"], name: "index_collectibles_on_document_id", using: :btree
  add_index "collectibles", ["name"], name: "index_collectibles_on_name", using: :btree
  add_index "collectibles", ["user_id"], name: "index_collectibles_on_user_id", using: :btree

  create_table "collections", force: true do |t|
    t.string   "name",             limit: 255,               null: false
    t.string   "slug",             limit: 255,               null: false
    t.text     "description",      limit: 65535
    t.integer  "user_id",          limit: 4,                 null: false
    t.integer  "view_scope",       limit: 4,     default: 3, null: false
    t.integer  "contribute_scope", limit: 4,     default: 3, null: false
    t.integer  "state",            limit: 4,     default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "collections", ["name"], name: "index_collections_on_name", using: :btree
  add_index "collections", ["slug"], name: "index_collections_on_slug", using: :btree
  add_index "collections", ["user_id"], name: "index_collections_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.integer  "commentable_id",   limit: 4,     default: 0
    t.string   "commentable_type", limit: 255
    t.string   "title",            limit: 255
    t.text     "body",             limit: 65535
    t.string   "subject",          limit: 255
    t.integer  "user_id",          limit: 4,     default: 0, null: false
    t.integer  "parent_id",        limit: 4
    t.integer  "lft",              limit: 4
    t.integer  "rgt",              limit: 4
    t.integer  "state",            limit: 4,     default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "connections", force: true do |t|
    t.integer  "user_id",    limit: 4,     null: false
    t.string   "service",    limit: 255,   null: false
    t.text     "followers",  limit: 65535
    t.text     "following",  limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "connections", ["user_id"], name: "index_connections_on_user_id", using: :btree

  create_table "documents", force: true do |t|
    t.string   "name",              limit: 255,               null: false
    t.string   "slug",              limit: 255,               null: false
    t.string   "url",               limit: 10000
    t.string   "file",              limit: 255
    t.string   "file_location",     limit: 255
    t.string   "thumb_sm",          limit: 255
    t.string   "thumb_md",          limit: 255
    t.string   "thumb_lg",          limit: 255
    t.string   "source",            limit: 255
    t.string   "principle_authors", limit: 255
    t.string   "other_authors",     limit: 255
    t.string   "rights",            limit: 255
    t.integer  "user_id",           limit: 4,                 null: false
    t.integer  "scope",             limit: 4,     default: 3, null: false
    t.integer  "state",             limit: 4,     default: 0, null: false
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["name"], name: "index_documents_on_name", using: :btree
  add_index "documents", ["slug"], name: "index_documents_on_slug", using: :btree
  add_index "documents", ["user_id"], name: "index_documents_on_user_id", using: :btree

  create_table "follows", force: true do |t|
    t.string   "follower_type",   limit: 255
    t.integer  "follower_id",     limit: 4
    t.string   "followable_type", limit: 255
    t.integer  "followable_id",   limit: 4
    t.datetime "created_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables", using: :btree
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows", using: :btree

  create_table "friendly_id_slugs", force: true do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",   limit: 4,   null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "likes", force: true do |t|
    t.string   "liker_type",    limit: 255
    t.integer  "liker_id",      limit: 4
    t.string   "likeable_type", limit: 255
    t.integer  "likeable_id",   limit: 4
    t.datetime "created_at"
  end

  add_index "likes", ["likeable_id", "likeable_type"], name: "fk_likeables", using: :btree
  add_index "likes", ["liker_id", "liker_type"], name: "fk_likes", using: :btree

  create_table "locations", force: true do |t|
    t.string   "name",       limit: 255,                           null: false
    t.decimal  "latitude",               precision: 15, scale: 10
    t.decimal  "longitude",              precision: 15, scale: 10
    t.string   "city",       limit: 255
    t.string   "state",      limit: 255
    t.string   "country",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "locations", ["name"], name: "index_locations_on_name", using: :btree

  create_table "memberships", force: true do |t|
    t.integer  "user_id",         limit: 4,                 null: false
    t.integer  "belongable_id",   limit: 4,                 null: false
    t.string   "belongable_type", limit: 255,               null: false
    t.integer  "creator_id",      limit: 4,                 null: false
    t.text     "notes",           limit: 65535
    t.integer  "scope",           limit: 4,     default: 3, null: false
    t.integer  "state",           limit: 4,     default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["belongable_id", "belongable_type"], name: "index_memberships_on_belongable_id_and_belongable_type", using: :btree
  add_index "memberships", ["creator_id"], name: "index_memberships_on_creator_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "mentions", force: true do |t|
    t.string   "mentioner_type",   limit: 255
    t.integer  "mentioner_id",     limit: 4
    t.string   "mentionable_type", limit: 255
    t.integer  "mentionable_id",   limit: 4
    t.datetime "created_at"
  end

  add_index "mentions", ["mentionable_id", "mentionable_type"], name: "fk_mentionables", using: :btree
  add_index "mentions", ["mentioner_id", "mentioner_type"], name: "fk_mentions", using: :btree

  create_table "presences", force: true do |t|
    t.integer  "location_id",    limit: 4,               null: false
    t.integer  "locatable_id",   limit: 4,               null: false
    t.string   "locatable_type", limit: 255,             null: false
    t.integer  "state",          limit: 4,   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "presences", ["locatable_id", "locatable_type"], name: "index_presences_on_locatable_id_and_locatable_type", using: :btree
  add_index "presences", ["location_id"], name: "index_presences_on_location_id", using: :btree

  create_table "searches", force: true do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.integer  "user_id",     limit: 4,                 null: false
    t.integer  "state",       limit: 4,     default: 0
    t.string   "term",        limit: 255
    t.string   "scope",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "searches", ["user_id"], name: "index_searches_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name",                   limit: 255,   default: ""
    t.string   "username",               limit: 255
    t.string   "description",            limit: 19000
    t.string   "image_url",              limit: 255
    t.string   "email",                  limit: 255,   default: "", null: false
    t.string   "encrypted_password",     limit: 255,   default: "", null: false
    t.integer  "creator_id",             limit: 4
    t.integer  "scope",                  limit: 4,     default: 3,  null: false
    t.integer  "state",                  limit: 4,     default: 0
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",        limit: 4,     default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["name"], name: "index_users_on_name", using: :btree

  create_table "votes", force: true do |t|
    t.integer  "votable_id",   limit: 4
    t.string   "votable_type", limit: 255
    t.integer  "voter_id",     limit: 4
    t.string   "voter_type",   limit: 255
    t.boolean  "vote_flag",    limit: 1
    t.string   "vote_scope",   limit: 255
    t.integer  "vote_weight",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

end
