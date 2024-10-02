module Authentication
  class UserReadModel < ApplicationRecord
    self.table_name = "users"
  end

  class Configuration
    def call(event_store, command_bus)
      event_store.subscribe(CreateUser, to: [Authentication::UserRegistered])
      event_store.subscribe(UpdateUserQuestProgress, to: [Authentication::QuestProgressUpdated])
      event_store.subscribe(AddUserReward, to: [Authentication::RewardClaimed])
    end
  end
end
