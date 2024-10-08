module Types
  class ActionExecutionType < Types::BaseObject
    field :id, ID, null: false, method: :execution_id
    field :action_id, ID, null: false
    field :user_id, ID, null: false
    field :action_type, String, null: false
    field :start_data, GraphQL::Types::JSON, null: false
    field :completion_data, GraphQL::Types::JSON, null: true
    field :status, String, null: false
    field :nonce, String, null: false
    field :started_at, GraphQL::Types::ISO8601DateTime, null: false
    field :completed_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end
