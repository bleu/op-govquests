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

ActiveRecord::Schema[8.0].define(version: 2024_09_30_201752) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_logs", force: :cascade do |t|
    t.string "action_log_id", null: false
    t.string "action_id", null: false
    t.string "user_id", null: false
    t.datetime "executed_at", null: false
    t.string "status", null: false
    t.jsonb "completion_data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_log_id"], name: "index_action_logs_on_action_log_id", unique: true
  end

  create_table "actions", force: :cascade do |t|
    t.string "action_id", null: false
    t.string "action_type", null: false
    t.jsonb "action_data", default: {}, null: false
    t.jsonb "display_data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["action_id"], name: "index_actions_on_action_id", unique: true
  end

  create_table "event_store_events", force: :cascade do |t|
    t.string "event_id", limit: 36, null: false
    t.string "event_type", null: false
    t.binary "metadata"
    t.binary "data", null: false
    t.datetime "created_at", null: false
    t.datetime "valid_at"
    t.index ["created_at"], name: "index_event_store_events_on_created_at"
    t.index ["event_id"], name: "index_event_store_events_on_event_id", unique: true
    t.index ["event_type"], name: "index_event_store_events_on_event_type"
    t.index ["valid_at"], name: "index_event_store_events_on_valid_at"
  end

  create_table "event_store_events_in_streams", force: :cascade do |t|
    t.string "stream", null: false
    t.integer "position"
    t.string "event_id", limit: 36, null: false
    t.datetime "created_at", null: false
    t.index ["created_at"], name: "index_event_store_events_in_streams_on_created_at"
    t.index ["event_id"], name: "index_event_store_events_in_streams_on_event_id"
    t.index ["stream", "event_id"], name: "index_event_store_events_in_streams_on_stream_and_event_id", unique: true
    t.index ["stream", "position"], name: "index_event_store_events_in_streams_on_stream_and_position", unique: true
  end

  create_table "leaderboard_entries", id: false, force: :cascade do |t|
    t.string "leaderboard_id", null: false
    t.string "profile_id", null: false
    t.integer "rank", null: false
    t.integer "score", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["leaderboard_id", "profile_id"], name: "index_leaderboard_entries_on_leaderboard_id_and_profile_id", unique: true
  end

  create_table "leaderboards", id: false, force: :cascade do |t|
    t.string "leaderboard_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["leaderboard_id"], name: "index_leaderboards_on_leaderboard_id", unique: true
  end

  create_table "notification_templates", force: :cascade do |t|
    t.string "template_id", null: false
    t.string "name", null: false
    t.text "content", null: false
    t.string "template_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_notification_templates_on_name", unique: true
    t.index ["template_id"], name: "index_notification_templates_on_template_id", unique: true
  end

  create_table "notifications", force: :cascade do |t|
    t.string "notification_id", null: false
    t.string "content", null: false
    t.integer "priority", null: false
    t.string "template_id", null: false
    t.string "user_id", null: false
    t.string "channel", null: false
    t.string "status", default: "created"
    t.string "notification_type", null: false
    t.datetime "scheduled_time"
    t.datetime "sent_at"
    t.datetime "received_at"
    t.datetime "opened_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel"], name: "index_notifications_on_channel"
    t.index ["notification_id"], name: "index_notifications_on_notification_id", unique: true
    t.index ["template_id"], name: "index_notifications_on_template_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "quest_actions", force: :cascade do |t|
    t.string "quest_id", null: false
    t.string "action_id", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quest_id", "action_id"], name: "index_quest_actions_on_quest_id_and_action_id", unique: true
    t.index ["quest_id", "position"], name: "index_quest_actions_on_quest_id_and_position", unique: true
  end

  create_table "quests", force: :cascade do |t|
    t.string "quest_id", null: false
    t.string "quest_type", null: false
    t.string "audience", null: false
    t.string "status", null: false
    t.jsonb "rewards", default: {}, null: false
    t.jsonb "display_data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quest_id"], name: "index_quests_on_quest_id", unique: true
  end

  create_table "rewards", force: :cascade do |t|
    t.string "reward_id", null: false
    t.string "reward_type", null: false
    t.integer "value", null: false
    t.datetime "expiry_date"
    t.string "issued_to"
    t.string "delivery_status", default: "Pending"
    t.boolean "claimed", default: false
    t.jsonb "display_data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reward_id"], name: "index_rewards_on_reward_id", unique: true
  end

  create_table "user_game_profiles", force: :cascade do |t|
    t.string "profile_id", null: false
    t.integer "tier", default: 0
    t.integer "track", default: 0
    t.integer "streak", default: 0
    t.integer "score", default: 0
    t.jsonb "badges", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_user_game_profiles_on_profile_id", unique: true
  end

  create_table "user_quests", force: :cascade do |t|
    t.string "quest_id", null: false
    t.string "user_id", null: false
    t.string "status", default: "started"
    t.integer "progress_measure", default: 0
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quest_id", "user_id"], name: "index_user_quests_on_quest_id_and_user_id", unique: true
  end

  create_table "user_rewards", force: :cascade do |t|
    t.string "user_id", null: false
    t.string "reward_id", null: false
    t.string "status", default: "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "reward_id"], name: "index_user_rewards_on_user_id_and_reward_id", unique: true
  end

  create_table "user_sessions", force: :cascade do |t|
    t.string "user_id", null: false
    t.string "session_token", null: false
    t.datetime "logged_in_at", null: false
    t.datetime "logged_out_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "user_id", null: false
    t.string "email", null: false
    t.string "user_type", default: "non_delegate", null: false
    t.jsonb "settings", default: {}
    t.jsonb "wallets", default: []
    t.jsonb "sessions", default: []
    t.jsonb "quests_progress", default: {}
    t.jsonb "activity_log", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["user_id"], name: "index_users_on_user_id", unique: true
  end

  add_foreign_key "event_store_events_in_streams", "event_store_events", column: "event_id", primary_key: "event_id"
  add_foreign_key "leaderboard_entries", "leaderboards", primary_key: "leaderboard_id"
end
