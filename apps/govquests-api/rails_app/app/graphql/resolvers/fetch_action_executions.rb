module Resolvers
  class FetchActionExecutions < BaseResolver
    type [Types::ActionExecutionType], null: true

    argument :action_id, ID, required: true

    def resolve(action_id:)
      current_user = context[:current_user]
      return unless current_user

      ActionTracking::ActionExecutionReadModel.where(
        action_id: action_id,
        user_id: current_user.user_id
      )
    end
  end
end
