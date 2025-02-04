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

ActiveRecord::Schema[8.1].define(version: 2025_02_03_185729) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "action_executions", force: :cascade do |t|
    t.string "execution_id", null: false
    t.string "action_id", null: false
    t.string "user_id", null: false
    t.datetime "started_at", null: false
    t.string "status", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "action_type"
    t.jsonb "result"
    t.datetime "completed_at"
    t.string "nonce", null: false
    t.jsonb "start_data", default: {}, null: false
    t.jsonb "completion_data", default: {}, null: false
    t.string "quest_id", null: false
    t.index ["execution_id"], name: "index_action_executions_on_execution_id", unique: true
  end

  create_table "actions", force: :cascade do |t|
    t.string "action_id", null: false
    t.string "action_type", null: false
    t.jsonb "action_data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "display_data", default: {}
    t.index ["action_id"], name: "index_actions_on_action_id", unique: true
  end

  create_table "badges", force: :cascade do |t|
    t.string "badge_id", null: false
    t.jsonb "display_data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "badgeable_type", null: false
    t.string "badgeable_id", null: false
    t.index ["badge_id"], name: "index_badges_on_badge_id", unique: true
    t.index ["badgeable_type", "badgeable_id"], name: "index_badges_on_badgeable_type_and_badgeable_id", unique: true
  end

  create_table "event_store_events", force: :cascade do |t|
    t.uuid "event_id", null: false
    t.string "event_type", null: false
    t.jsonb "metadata"
    t.jsonb "data", null: false
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
    t.uuid "event_id", null: false
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

  create_table "notification_deliveries", force: :cascade do |t|
    t.string "notification_id", null: false
    t.string "delivery_method", null: false
    t.string "status", default: "pending", null: false
    t.datetime "delivered_at"
    t.datetime "read_at"
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_id", "delivery_method"], name: "idx_on_notification_id_delivery_method_fcac4b8c69", unique: true
    t.index ["notification_id"], name: "index_notification_deliveries_on_notification_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "notification_id", null: false
    t.string "user_id", null: false
    t.string "content", null: false
    t.string "notification_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notification_id"], name: "index_notifications_on_notification_id", unique: true
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
    t.string "audience", null: false
    t.string "status", null: false
    t.jsonb "display_data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "track_id"
    t.index ["quest_id"], name: "index_quests_on_quest_id", unique: true
    t.index ["track_id"], name: "index_quests_on_track_id"
  end

  create_table "reward_issuances", force: :cascade do |t|
    t.uuid "pool_id", null: false
    t.uuid "user_id", null: false
    t.datetime "issued_at", null: false
    t.datetime "claim_started_at"
    t.datetime "claim_completed_at"
    t.jsonb "claim_metadata", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pool_id", "user_id"], name: "index_reward_issuances_on_pool_id_and_user_id", unique: true
    t.index ["user_id"], name: "index_reward_issuances_on_user_id"
  end

  create_table "reward_pools", force: :cascade do |t|
    t.uuid "pool_id", null: false
    t.uuid "quest_id", null: false
    t.jsonb "reward_definition", null: false
    t.integer "remaining_inventory"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pool_id"], name: "index_reward_pools_on_pool_id", unique: true
    t.index ["quest_id"], name: "index_reward_pools_on_quest_id"
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

  create_table "special_badges", force: :cascade do |t|
    t.string "badge_id", null: false
    t.jsonb "display_data", null: false
    t.string "badge_type", null: false
    t.jsonb "badge_data", null: false
    t.integer "points", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["badge_id"], name: "index_special_badges_on_badge_id", unique: true
  end

  create_table "track_quests", force: :cascade do |t|
    t.string "track_id", null: false
    t.string "quest_id", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["track_id", "position"], name: "index_track_quests_on_track_id_and_position", unique: true
    t.index ["track_id", "quest_id"], name: "index_track_quests_on_track_id_and_quest_id", unique: true
  end

  create_table "tracks", force: :cascade do |t|
    t.string "track_id", null: false
    t.jsonb "display_data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "quest_ids", default: [], array: true
    t.index ["track_id"], name: "index_tracks_on_track_id", unique: true
  end

  create_table "user_badges", force: :cascade do |t|
    t.string "user_id", null: false
    t.string "badge_type", null: false
    t.string "badge_id", null: false
    t.datetime "earned_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["badge_type", "badge_id"], name: "index_user_badges_on_badge_type_and_badge_id"
    t.index ["earned_at"], name: "index_user_badges_on_earned_at"
    t.index ["user_id", "badge_type", "badge_id"], name: "unique_normal_badges_index", unique: true, where: "((badge_type)::text = 'Gamification::BadgeReadModel'::text)"
  end

  create_table "user_game_profiles", force: :cascade do |t|
    t.string "profile_id", null: false
    t.integer "tier", default: 0
    t.integer "track", default: 0
    t.integer "streak", default: 0
    t.integer "score", default: 0
    t.jsonb "badges", default: []
    t.jsonb "unclaimed_tokens", default: {}
    t.jsonb "active_claim"
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
    t.string "user_quest_id", null: false
    t.index ["quest_id", "user_id"], name: "index_user_quests_on_quest_id_and_user_id", unique: true
    t.index ["user_quest_id"], name: "index_user_quests_on_user_quest_id", unique: true
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

  create_table "user_tracks", force: :cascade do |t|
    t.string "track_id", null: false
    t.string "user_id", null: false
    t.string "status", default: "in_progress", null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_track_id"
    t.index ["status"], name: "index_user_tracks_on_status"
    t.index ["track_id"], name: "index_user_tracks_on_track_id"
    t.index ["user_id", "track_id"], name: "index_user_tracks_on_user_id_and_track_id", unique: true
    t.index ["user_track_id"], name: "index_user_tracks_on_user_track_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "user_id", null: false
    t.string "email"
    t.string "user_type", default: "non_delegate", null: false
    t.jsonb "settings", default: {}
    t.jsonb "sessions", default: []
    t.jsonb "quests_progress", default: {}
    t.jsonb "activity_log", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "address", null: false
    t.integer "chain_id", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["user_id"], name: "index_users_on_user_id", unique: true
  end

  add_foreign_key "event_store_events_in_streams", "event_store_events", column: "event_id", primary_key: "event_id"
  add_foreign_key "leaderboard_entries", "leaderboards", primary_key: "leaderboard_id"
end
