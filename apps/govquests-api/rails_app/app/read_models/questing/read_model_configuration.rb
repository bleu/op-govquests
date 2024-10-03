module Questing
  class QuestReadModel < ApplicationRecord
    self.table_name = "quests"
  end

  class UserQuest < ApplicationRecord
    self.table_name = "user_quests"
  end

  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnQuestCreated, to: [ Questing::QuestCreated ])
      event_store.subscribe(OnUserStartedQuest, to: [ Questing::UserStartedQuest ])
    end
  end
end
