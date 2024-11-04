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

# == Schema Information
#
# Table name: action_executions
#
#  id              :bigint           not null, primary key
#  action_type     :string
#  completed_at    :datetime
#  completion_data :jsonb            not null
#  nonce           :string           not null
#  result          :jsonb
#  start_data      :jsonb            not null
#  started_at      :datetime         not null
#  status          :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  action_id       :string           not null
#  execution_id    :string           not null
#  quest_id        :string           not null
#  user_id         :string           not null
#
# Indexes
#
#  index_action_executions_on_execution_id  (execution_id) UNIQUE
#
