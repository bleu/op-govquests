module Questing
  class QuestReadModel < ApplicationRecord
    self.table_name = "quests"

    has_many :quest_actions, -> { order(position: :asc) }, class_name: "Questing::QuestActionReadModel", foreign_key: "quest_id", primary_key: "quest_id"
    has_many :actions, through: :quest_actions, source: :action, class_name: "ActionTracking::ActionReadModel"

    validates :quest_id, presence: true, uniqueness: true
    validates :quest_type, presence: true
    validates :audience, presence: true
    validates :status, presence: true
    validates :rewards, presence: true
    validates :display_data, presence: true
  end
end
