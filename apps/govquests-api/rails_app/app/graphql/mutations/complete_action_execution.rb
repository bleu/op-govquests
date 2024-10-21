module Mutations
  class CompleteActionExecution < BaseMutation
    argument :execution_id, ID, required: true
    argument :nonce, String, required: true
    argument :action_type, String, required: true, description: "Type of the action"

    argument :gitcoin_score_completion_data, Types::GitcoinScoreCompletionDataInput, required: false, description: "Completion data for Gitcoin Score action"
    argument :read_document_completion_data, Types::ReadDocumentCompletionDataInput, required: false, description: "Completion data for Read Document action"
    argument :ens_completion_data, Types::ActionExecution::Strategies::Ens::EnsCompletionDataInputType, required: false, description: "Completion data for ENS action"
    argument :discourse_verification_completion_data, Types::ActionExecution::Strategies::DiscourseVerification::DiscourseVerificationCompletionDataInput, required: false

    field :action_execution, Types::ActionExecutionType, null: true
    field :errors, [String], null: false

    def resolve(execution_id:, nonce:, action_type:, gitcoin_score_completion_data: nil, read_document_completion_data: nil, ens_completion_data: nil, discourse_verification_completion_data: nil)
      completion_data = case action_type
      when "gitcoin_score"
        gitcoin_score_completion_data&.to_h || {}
      when "read_document"
        read_document_completion_data&.to_h || {}
      when "ens"
        ens_completion_data&.to_h || {}
      when "discourse_verification"
        discourse_verification_completion_data&.to_h || {}
      else
        {}
      end

      result = ActionTracking::ActionExecutionService.complete(
        execution_id: execution_id,
        nonce: nonce,
        user_id: context[:current_user]&.user_id,
        completion_data: completion_data,
        action_type: action_type
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
