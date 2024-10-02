module Questing
  class QuestReadModel < ApplicationRecord
    self.table_name = "quests"
  end

  class Configuration
    def call(event_store, command_bus)
      event_store.subscribe(CreateQuest, to: [Questing::QuestCreated])
    end
  end
end
