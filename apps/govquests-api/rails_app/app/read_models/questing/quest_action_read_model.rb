module Questing
class QuestActionReadModel < ApplicationRecord
    self.table_name = "quest_actions"

    belongs_to :quest, class_name: "Questing::QuestReadModel", foreign_key: "quest_id", primary_key: "quest_id"
    belongs_to :action, class_name: "ActionTracking::ActionReadModel", foreign_key: "action_id", primary_key: "action_id"
  end
end