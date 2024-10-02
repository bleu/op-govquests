module Questing
  class QuestReadModel < ApplicationRecord
    self.table_name = "quests"
  end

  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnQuestCreated, to: [ Questing::QuestCreated ])
    end
  end
end
