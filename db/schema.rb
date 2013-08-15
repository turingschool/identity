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

ActiveRecord::Schema.define(version: 20130814201940) do

  create_table "applications", force: true do |t|
    t.integer "user_id"
    t.string  "resume"
    t.string  "essay_url"
    t.string  "video_url"
    t.string  "completed_steps"
  end

  add_index "applications", ["user_id"], name: "index_applications_on_user_id"

  create_table "criteria", force: true do |t|
    t.integer  "evaluation_id"
    t.string   "title"
    t.text     "notes"
    t.text     "options"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "criteria", ["evaluation_id"], name: "index_criteria_on_evaluation_id"

  create_table "evaluations", force: true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.integer  "application_id"
    t.datetime "completed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "evaluations", ["application_id"], name: "index_evaluations_on_application_id"
  add_index "evaluations", ["user_id"], name: "index_evaluations_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "location"
    t.string   "username"
    t.string   "github_id"
    t.string   "avatar_url"
    t.string   "gravatar_id"
    t.boolean  "is_admin",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
