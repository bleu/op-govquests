module Mutations
  class CompleteActionExecution < BaseMutation
    argument :execution_id, ID, required: true
    argument :nonce, String, required: true
    argument :action_type, String, required: true, description: "Type of the action"
    argument :gitcoin_score_completion_data, Types::GitcoinScoreCompletionDataInput, required: false, description: "Completion data for Gitcoin Score action"
    argument :read_document_completion_data, Types::ReadDocumentCompletionDataInput, required: false, description: "Completion data for Read Document action"

    field :action_execution, Types::ActionExecutionType, null: true
    field :errors, [String], null: false
    field :score, Float, null: true
    field :passed_threshold, Boolean, null: true

    def resolve(execution_id:, nonce:, action_type:, gitcoin_score_completion_data: nil, read_document_completion_data: nil)
      completion_data = case action_type
      when "gitcoin_score"
        gitcoin_score_completion_data&.to_h || {}
      when "read_document"
        read_document_completion_data&.to_h || {}
      else
        {}
      end

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
