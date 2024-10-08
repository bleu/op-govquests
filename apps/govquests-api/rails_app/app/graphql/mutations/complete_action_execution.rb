module Mutations
  class CompleteActionExecution < BaseMutation
    argument :execution_id, ID, required: true
    argument :nonce, String, required: true
    argument :completion_data, GraphQL::Types::JSON, required: false

    field :action_execution, Types::ActionExecutionType, null: true
    field :errors, [String], null: false

    def resolve(execution_id:, nonce:, completion_data: {})
      result = ActionTracking::ActionExecutionService.complete(
        execution_id: execution_id,
        nonce: nonce,
        user_id: context[:current_user]&.user_id,
        completion_data: completion_data
      )

      if result.is_a?(ActionTracking::ActionExecutionReadModel)
        {
          action_execution: result,
          errors: []
        }
      else
        {
          action_execution: nil,
          errors: [result[:error]]
        }
      end
    end
  end
end
