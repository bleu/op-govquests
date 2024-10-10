module ActionTracking
  class ActionExecutionReadModel < ApplicationRecord
    self.table_name = "action_executions"

    validates :execution_id, presence: true, uniqueness: true
    validates :action_id, presence: true
    validates :user_id, presence: true
    # validates :quest_id, presence: true
    validates :action_type, presence: true
    validates :started_at, presence: true
    validates :status, presence: true

    belongs_to :action, foreign_key: :action_id, primary_key: :action_id, class_name: "ActionTracking::ActionReadModel"
    belongs_to :user, foreign_key: :user_id, primary_key: :user_id, class_name: "Authentication::UserReadModel"
    # belongs_to :quest, foreign_key: :quest_id, primary_key: :quest_id, class_name: "Questing::QuestReadModel", optional: true
  end
end
