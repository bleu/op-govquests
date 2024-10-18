module Types
  class ActionExecutionType < Types::BaseObject
    field :id, ID, null: false, method: :execution_id
    field :action_id, ID, null: false
    field :user_id, ID, null: false
    field :action_type, String, null: false

    field :action_data, Types::ActionDataInterface, null: true, description: "Data defining the action"
    field :start_data, Types::StartDataInterface, null: true, description: "Data required to start the action"
    field :completion_data, Types::CompletionDataInterface, null: true, description: "Data provided upon action completion"

    field :status, String, null: false
    field :nonce, String, null: false
    field :started_at, GraphQL::Types::ISO8601DateTime, null: false
    field :completed_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end
