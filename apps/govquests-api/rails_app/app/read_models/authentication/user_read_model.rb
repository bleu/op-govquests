module Authentication
  class UserReadModel < ApplicationRecord
    self.table_name = "users"

    validates :address, presence: true, uniqueness: true
    validates :user_type, presence: true, inclusion: {in: %w[delegate non_delegate]}

    has_many :sessions, class_name: "Authentication::SessionReadModel", foreign_key: :user_id
    has_many :rewards,
      -> { where.not(claimed_at: nil) },
      class_name: "Rewarding::RewardPoolReadModel",
      foreign_key: "user_id",
      primary_key: "user_id"

    has_many :user_badges,
      class_name: "Gamification::UserBadgeReadModel",
      foreign_key: :user_id,
      primary_key: :user_id

    has_many :user_quests,
      class_name: "Questing::UserQuestReadModel",
      foreign_key: :user_id,
      primary_key: :user_id

    has_many :user_track,
      class_name: "Questing::UserTrackReadModel",
      foreign_key: :user_id,
      primary_key: :user_id

    has_one :game_profile,
      class_name: "Gamification::GameProfileReadModel",
      foreign_key: :profile_id,
      primary_key: :user_id

    has_many :notifications, class_name: "Notifications::NotificationReadModel", foreign_key: :user_id, primary_key: :user_id
  end
end

# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  activity_log    :jsonb
#  address         :string           not null
#  email           :string
#  quests_progress :jsonb
#  sessions        :jsonb
#  settings        :jsonb
#  user_type       :string           default("non_delegate"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  chain_id        :integer          not null
#  user_id         :string           not null
#
# Indexes
#
#  index_users_on_email    (email) UNIQUE
#  index_users_on_user_id  (user_id) UNIQUE
#
