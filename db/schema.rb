# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2025_03_31_115122) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "goalie_stats", force: :cascade do |t|
    t.integer "season_id"
    t.bigint "player_id", null: false
    t.string "time_on_ice"
    t.integer "ot"
    t.integer "shutouts"
    t.integer "wins"
    t.integer "losses"
    t.integer "saves"
    t.float "save_percentage"
    t.float "goals_against_average"
    t.float "power_play_save_percentage"
    t.float "short_handed_save_percentage"
    t.float "even_strength_save_percentage"
    t.integer "games"
    t.integer "games_started"
    t.integer "shots_against"
    t.integer "goals_against"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_goalie_stats_on_player_id"
  end

  create_table "nhl_teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.string "tricode"
  end

  create_table "players", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "full_name"
    t.integer "jersey_number"
    t.string "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "nhl_team_id", null: false
    t.index ["nhl_team_id"], name: "index_players_on_nhl_team_id"
  end

  create_table "skater_stats", force: :cascade do |t|
    t.integer "season_id"
    t.bigint "player_id", null: false
    t.string "time_on_ice"
    t.integer "assists"
    t.integer "goals"
    t.integer "pim"
    t.integer "shots"
    t.integer "games"
    t.integer "hits"
    t.integer "power_play_goals"
    t.integer "power_play_points"
    t.string "power_play_time_on_ice"
    t.float "faceoff_pct"
    t.float "shot_pct"
    t.integer "game_winning_goals"
    t.integer "short_handed_goals"
    t.integer "short_handed_points"
    t.integer "blocked"
    t.integer "plus_minus"
    t.integer "points"
    t.string "time_on_ice_per_game"
    t.string "even_time_on_ice_per_game"
    t.string "short_handed_time_on_ice_per_game"
    t.string "power_play_time_on_ice_per_game"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_skater_stats_on_player_id"
  end

  create_table "team_players", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "player_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_team_players_on_player_id"
    t.index ["team_id"], name: "index_team_players_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_teams_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "goalie_stats", "players"
  add_foreign_key "players", "nhl_teams"
  add_foreign_key "skater_stats", "players"
  add_foreign_key "team_players", "players"
  add_foreign_key "team_players", "teams"
  add_foreign_key "teams", "users"
end
