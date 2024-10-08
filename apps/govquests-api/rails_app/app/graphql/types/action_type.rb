module Types
  class ActionType < Types::BaseObject
    field :id, ID, null: false, method: :action_id
    field :action_type, String, null: false
    field :action_data, GraphQL::Types::JSON, null: false
    field :display_data, Types::DisplayDataType, null: false

    field :action_executions, [Types::ActionExecutionType], null: true

    def action_executions
      current_user = context[:current_user]
      return unless current_user

      ActionTracking::ActionExecutionReadModel.where(
        action_id: object.action_id,
        user_id: current_user.user_id
      )
    end
  end
end
