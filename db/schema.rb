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

ActiveRecord::Schema.define(version: 20160628160604) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blocks", force: :cascade do |t|
    t.integer  "event_id",                                          null: false
    t.datetime "start_time",                                        null: false
    t.datetime "end_time",                                          null: false
    t.string   "time_zone",  default: "Eastern Time (US & Canada)", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "name",          null: false
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "group_id",      null: false
    t.string   "location"
    t.integer  "slot_duration", null: false
    t.string   "calendar_id"
    t.string   "calendar_name"
  end

  create_table "groups", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name",       null: false
    t.datetime "last_used"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", force: :cascade do |t|
    t.integer "group_id"
    t.integer "person_id"
  end

  create_table "people", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "person_slot_restrictions", force: :cascade do |t|
    t.integer "person_id"
    t.integer "slot_id"
  end

  create_table "scheduled_spots", force: :cascade do |t|
    t.integer  "person_id",  null: false
    t.integer  "slot_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "slots", force: :cascade do |t|
    t.integer  "block_id"
    t.integer  "available_spots",                                        null: false
    t.datetime "start_time",                                             null: false
    t.datetime "end_time",                                               null: false
    t.string   "time_zone",       default: "Eastern Time (US & Canada)", null: false
  end

  create_table "tokens", force: :cascade do |t|
    t.integer  "user_id",       null: false
    t.string   "provider",      null: false
    t.string   "access_token",  null: false
    t.string   "refresh_token"
    t.datetime "expires_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "uid",        null: false
    t.string   "avatar_url"
    t.string   "first_name", null: false
    t.string   "last_name"
    t.string   "email",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "provider",   null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

end
