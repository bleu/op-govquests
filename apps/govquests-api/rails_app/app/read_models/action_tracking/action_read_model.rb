module ActionTracking
  class ActionReadModel < ApplicationRecord
    self.table_name = "actions"

    validates :action_id, presence: true, uniqueness: true
    validates :action_type, presence: true
    validates :action_data, presence: true
    validates :display_data, presence: true

    has_many :action_executions, foreign_key: :action_id, primary_key: :action_id, class_name: "ActionTracking::ActionExecutionReadModel"
  end
end
