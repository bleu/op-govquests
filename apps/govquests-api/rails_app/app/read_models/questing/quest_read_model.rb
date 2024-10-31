module Questing
  class QuestReadModel < ApplicationRecord
    self.table_name = "quests"

    has_many :quest_actions, -> { order(position: :asc) }, class_name: "Questing::QuestActionReadModel", foreign_key: "quest_id", primary_key: "quest_id"
    has_many :actions, through: :quest_actions, source: :action, class_name: "ActionTracking::ActionReadModel"
    has_many :user_quests, class_name: "Questing::UserQuestReadModel", foreign_key: "quest_id", primary_key: "quest_id"
    has_many :reward_pools, class_name: "Rewarding::RewardPoolReadModel", foreign_key: "quest_id", primary_key: "quest_id"

    validates :quest_id, presence: true, uniqueness: true
    validates :audience, presence: true
    validates :status, presence: true
    validates :display_data, presence: true
  end
end
