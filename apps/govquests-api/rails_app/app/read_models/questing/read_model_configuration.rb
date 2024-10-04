module Questing
  class QuestReadModel < ApplicationRecord
    self.table_name = "quests"

    has_many :quest_actions, class_name: "Questing::QuestActionReadModel", foreign_key: "quest_id"

    def title
      display_data["title"]
    end

    def intro
      display_data["intro"]
    end

    def image_url
      display_data["image_url"]
    end
  end

  class QuestActionReadModel < ApplicationRecord
    self.table_name = "quest_actions"
    belongs_to :quest, class_name: "Questing::QuestReadModel", foreign_key: "quest_id", primary_key: "quest_id"
    belongs_to :action, class_name: "ActionTracking::ActionReadModel", foreign_key: "action_id", primary_key: "action_id"
  end

  class UserQuest < ApplicationRecord
    self.table_name = "user_quests"
  end

  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnQuestCreated, to: [ Questing::QuestCreated ])
      event_store.subscribe(OnActionAssociatedWithQuest, to: [ Questing::ActionAssociatedWithQuest ])
      # event_store.subscribe(OnUserStartedQuest, to: [Questing::UserStartedQuest])
    end
  end
end
