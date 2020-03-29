# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_29_040045) do

  create_table "divisions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "uuid"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "draft_window", default: 6
    t.integer "draft_team_sort", default: 0
  end

  create_table "players", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "division_id"
    t.string "first_name"
    t.string "last_name"
    t.bigint "team_id"
    t.bigint "auto_draft_team_id"
    t.integer "pitching"
    t.integer "catching"
    t.integer "overall"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "draft_order"
    t.index ["auto_draft_team_id"], name: "index_players_on_auto_draft_team_id"
    t.index ["division_id"], name: "index_players_on_division_id"
    t.index ["team_id"], name: "index_players_on_team_id"
  end

  create_table "teams", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "division_id"
    t.string "team_name"
    t.string "coach_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "draft_position"
    t.index ["division_id"], name: "index_teams_on_division_id"
  end

  add_foreign_key "players", "divisions"
  add_foreign_key "players", "teams"
  add_foreign_key "players", "teams", column: "auto_draft_team_id"
  add_foreign_key "teams", "divisions"
end
