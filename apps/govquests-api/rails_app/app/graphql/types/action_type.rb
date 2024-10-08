module Types
  class ActionType < Types::BaseObject
    field :id, ID, null: false, method: :action_id
    field :action_type, String, null: false
    field :action_data, GraphQL::Types::JSON, null: false
    field :display_data, Types::DisplayDataType, null: false
  end
end
