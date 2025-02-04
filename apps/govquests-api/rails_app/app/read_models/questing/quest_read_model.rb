module Questing
  class QuestReadModel < ApplicationRecord
    self.table_name = "quests"

    has_many :quest_actions, -> { order(position: :asc) }, class_name: "Questing::QuestActionReadModel", foreign_key: "quest_id", primary_key: "quest_id"
    has_many :actions, through: :quest_actions, source: :action, class_name: "ActionTracking::ActionReadModel"
    has_many :user_quests, class_name: "Questing::UserQuestReadModel", foreign_key: "quest_id", primary_key: "quest_id"

    has_many :reward_pools,
      class_name: "Rewarding::RewardPoolReadModel",
      as: :rewardable

    belongs_to :track,
      class_name: "Questing::TrackReadModel",
      foreign_key: "track_id",
      primary_key: "track_id",
      optional: true

    validates :quest_id, presence: true, uniqueness: true
    validates :slug, presence: true
    validates :audience, presence: true
    validates :status, presence: true
    validates :display_data, presence: true

    has_one :badge,
      class_name: "Gamification::BadgeReadModel",
      as: :badgeable

    has_one :track_quest, class_name: "Questing::TrackQuestReadModel", foreign_key: "quest_id", primary_key: "quest_id"
  end
end

# == Schema Information
#
# Table name: quests
#
#  id           :bigint           not null, primary key
#  audience     :string           not null
#  display_data :jsonb            not null
#  slug         :string
#  status       :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  quest_id     :string           not null
#  track_id     :string
#
# Indexes
#
#  index_quests_on_quest_id  (quest_id) UNIQUE
#  index_quests_on_track_id  (track_id)
#
