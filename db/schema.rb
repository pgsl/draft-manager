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

ActiveRecord::Schema.define(version: 20171221051047) do

  create_table "divisions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "uuid"
    t.string "name"
    t.string "skills"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "players", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "division_id"
    t.string "first_name"
    t.string "last_name"
    t.bigint "team_id"
    t.bigint "auto_draft_team_id"
    t.integer "skill_1"
    t.integer "skill_2"
    t.integer "skill_3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["auto_draft_team_id"], name: "index_players_on_auto_draft_team_id"
    t.index ["division_id"], name: "index_players_on_division_id"
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "teams", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "division_id"
    t.string "team_name"
    t.string "coach_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["division_id"], name: "index_teams_on_division_id"
  end

  add_foreign_key "players", "divisions"
  add_foreign_key "players", "teams"
  add_foreign_key "players", "teams", column: "auto_draft_team_id"
  add_foreign_key "teams", "divisions"
end