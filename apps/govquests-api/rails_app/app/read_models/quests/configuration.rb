module Quests
  class Quest < ApplicationRecord
    self.table_name = "quests"
  end

  class Configuration
    def call(event_store)
      event_store.subscribe(CreateQuest, to: [ Questing::QuestRegistered ])
    end
  end
end
