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

ActiveRecord::Schema.define(version: 20140630225144) do

  create_table "categories", id: false, force: true do |t|
    t.integer  "id",         null: false
    t.text     "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "grammar_rules", id: false, force: true do |t|
    t.integer  "id",              null: false
    t.string   "identifier"
    t.text     "description"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "practice_lesson"
    t.integer  "author_id"
  end

  create_table "grammar_tests", id: false, force: true do |t|
    t.integer  "id",         null: false
    t.text     "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rule_examples", id: false, force: true do |t|
    t.integer  "id",                         null: false
    t.text     "title"
    t.boolean  "correct",    default: false, null: false
    t.text     "text"
    t.integer  "rule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rule_question_inputs", id: false, force: true do |t|
    t.integer  "id",                  null: false
    t.string   "step"
    t.integer  "rule_question_id"
    t.integer  "score_id"
    t.text     "first_input"
    t.text     "second_input"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "activity_session_id"
  end

  create_table "rule_questions", id: false, force: true do |t|
    t.integer  "id",           null: false
    t.text     "body"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "rule_id"
    t.text     "prompt"
    t.text     "instructions"
    t.text     "hint"
  end

  create_table "rules", id: false, force: true do |t|
    t.integer  "id",                          null: false
    t.text     "name"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "category_id"
    t.integer  "workbook_id",    default: 1
    t.text     "description"
    t.string   "classification"
    t.string   "uid"
    t.string   "flags",          default: [], null: false, array: true
  end

  create_table "rules_misseds", id: false, force: true do |t|
    t.integer  "id",            null: false
    t.integer  "rule_id"
    t.integer  "user_id"
    t.integer  "assessment_id"
    t.datetime "time_take"
    t.boolean  "missed"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
