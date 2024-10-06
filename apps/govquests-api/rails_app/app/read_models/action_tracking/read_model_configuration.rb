# rails_app/app/read_models/action_tracking/read_model_configuration.rb
module ActionTracking
  class ActionReadModel < ApplicationRecord
    self.table_name = "actions"

    validates :action_id, presence: true, uniqueness: true
    validates :action_type, presence: true
    validates :action_data, presence: true
  end

  class ActionExecutionReadModel < ApplicationRecord
    self.table_name = "action_executions"

    validates :execution_id, presence: true, uniqueness: true
    validates :action_id, presence: true
    validates :user_id, presence: true
    validates :action_type, presence: true
    validates :started_at, presence: true
    validates :status, presence: true
  end

  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnActionCreated, to: [ActionTracking::ActionCreated])
      event_store.subscribe(OnActionExecutionStarted, to: [ActionTracking::ActionExecutionStarted])
      event_store.subscribe(OnActionExecutionCompleted, to: [ActionTracking::ActionExecutionCompleted])
    end
  end
end
