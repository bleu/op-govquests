# app/graphql/mutations/start_action_execution.rb
module Mutations
  class StartActionExecution < BaseMutation
    argument :quest_id, ID, required: true
    argument :action_id, ID, required: true
    argument :start_data, GraphQL::Types::JSON, required: false

    field :action_execution, Types::ActionExecutionType, null: true
    field :errors, [String], null: false

    def resolve(quest_id:, action_id:, start_data: {})
      result = ActionTracking::ActionExecutionService.start(
        quest_id: quest_id,
        action_id: action_id,
        user_id: context[:current_user]&.user_id,
        start_data: start_data
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
