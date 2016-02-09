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

ActiveRecord::Schema.define(version: 20150901151051) do

  create_table "free_learn_scorm_creator_event_mappings", force: :cascade do |t|
    t.integer  "game_template_event_id"
    t.integer  "game_id"
    t.integer  "lo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "free_learn_scorm_creator_game_template_events", force: :cascade do |t|
    t.integer  "game_template_id"
    t.string   "name"
    t.string   "description"
    t.string   "event_type"
    t.integer  "id_in_game"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "free_learn_scorm_creator_game_templates", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "avatar_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "free_learn_scorm_creator_games", force: :cascade do |t|
    t.integer  "game_template_id"
    t.string   "name"
    t.string   "description"
    t.string   "avatar_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "free_learn_scorm_creator_los", force: :cascade do |t|
    t.integer  "scorm_file_id"
    t.string   "lo_type"
    t.string   "scorm_type"
    t.string   "href"
    t.string   "metadata"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "free_learn_scorm_creator_scorm_files", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "avatar_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source_file_name"
    t.string   "source_content_type"
    t.integer  "source_file_size"
    t.datetime "source_updated_at"
  end

  create_table "free_learn_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin"
  end

  add_index "free_learn_users", ["email"], name: "index_free_learn_users_on_email", unique: true
  add_index "free_learn_users", ["reset_password_token"], name: "index_free_learn_users_on_reset_password_token", unique: true

end
