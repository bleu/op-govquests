module Questing
class QuestReadModel < ApplicationRecord
    self.table_name = "quests"

    has_many :quest_actions, -> { order(position: :asc) }, class_name: "Questing::QuestActionReadModel", foreign_key: "quest_id", primary_key: "quest_id"
    has_many :actions, through: :quest_actions, source: :action, class_name: "ActionTracking::ActionReadModel"
  end
end