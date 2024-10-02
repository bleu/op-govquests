module Authentication
  class UserReadModel < ApplicationRecord
    self.table_name = "users"
  end

  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnCreateUser, to: [ Authentication::UserRegistered ])
    end
  end
end
