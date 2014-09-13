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

ActiveRecord::Schema.define(version: 20140913220842) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "pg_stat_statements"

  create_table "categories", force: true do |t|
    t.text     "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chapter_levels", force: true do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "workbook_id"
  end

  create_table "chapters", force: true do |t|
    t.string   "title"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "workbook_id"
    t.text     "article_header"
    t.text     "rule_position"
    t.text     "description"
    t.text     "practice_description"
    t.integer  "chapter_level_id"
  end

  add_index "chapters", ["chapter_level_id"], name: "index_chapters_on_chapter_level_id", using: :btree
  add_index "chapters", ["rule_position"], name: "index_chapters_on_rule_position", using: :btree

  create_table "rule_examples", force: true do |t|
    t.text     "title"
    t.boolean  "correct",    default: false, null: false
    t.text     "text"
    t.integer  "rule_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rule_examples", ["rule_id"], name: "index_rule_examples_on_rule_id", using: :btree

  create_table "rule_question_inputs", force: true do |t|
    t.string   "step"
    t.integer  "rule_question_id"
    t.integer  "score_id"
    t.text     "first_input"
    t.text     "second_input"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "activity_session_id"
  end

  add_index "rule_question_inputs", ["activity_session_id"], name: "index_rule_question_inputs_on_activity_session_id", using: :btree
  add_index "rule_question_inputs", ["rule_question_id"], name: "index_rule_question_inputs_on_rule_question_id", using: :btree
  add_index "rule_question_inputs", ["score_id"], name: "index_rule_question_inputs_on_score_id", using: :btree

  create_table "rule_questions", force: true do |t|
    t.text     "body"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "rule_id"
    t.text     "prompt"
    t.text     "instructions"
    t.text     "hint"
  end

  add_index "rule_questions", ["rule_id"], name: "index_rule_questions_on_rule_id", using: :btree

  create_table "rules", force: true do |t|
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

  add_index "rules", ["category_id"], name: "index_rules_on_category_id", using: :btree
  add_index "rules", ["uid"], name: "index_rules_on_uid", unique: true, using: :btree

end
