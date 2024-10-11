module Questing
  class UserQuestReadModel < ApplicationRecord
    self.table_name = "user_quests"

    belongs_to :quest, class_name: "Questing::QuestReadModel", foreign_key: "quest_id", primary_key: "quest_id"
    belongs_to :user, class_name: "Authentication::UserReadModel", foreign_key: "user_id", primary_key: "user_id"
  end
end
