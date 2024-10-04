# rails_app/app/read_models/action_tracking/read_model_configuration.rb
module ActionTracking
  class ActionReadModel < ApplicationRecord
    self.table_name = "actions"

    validates :action_id, presence: true, uniqueness: true

    def content
      display_data["content"]
    end

    def duration
      display_data["duration"]
    end
  end

  class ActionLogReadModel < ApplicationRecord
    self.table_name = "action_logs"

    validates :action_log_id, presence: true, uniqueness: true
    validates :action_id, presence: true
    validates :user_id, presence: true
    validates :executed_at, presence: true
    validates :status, presence: true
  end

  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnActionCreated, to: [ActionTracking::ActionCreated])
      event_store.subscribe(OnActionExecuted, to: [ActionTracking::ActionExecuted])
    end
  end
end
