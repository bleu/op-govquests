module Types
  class ActionType < Types::BaseObject
    field :id, ID, null: false, method: :action_id
    field :action_type, String, null: false
    field :action_data, Types::ActionDataInterface, null: true, description: "Data defining the action"
    field :display_data, Types::ActionDisplayDataType, null: false

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
