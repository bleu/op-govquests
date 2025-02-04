module Mutations
  class StartActionExecution < BaseMutation
    argument :quest_id, ID, required: true
    argument :action_id, ID, required: true
    argument :action_type, String, required: true, description: "Type of the action"
    argument :send_email_verification_input, Types::Inputs::SendEmailVerificationInput, required: false

    field :action_execution, Types::ActionExecutionType, null: true
    field :errors, [String], null: false

    def resolve(quest_id:, action_id:, action_type:, send_email_verification_input: nil)
      action = ActionTracking::ActionReadModel.find_by(action_id: action_id)
      unless action
        return {action_execution: nil, errors: ["Action not found"]}
      end

      start_data = case action_type
      when "ens", "wallet_verification", "verify_delegate_statement",
        "verify_delegate", "verify_first_vote", "holds_op", "governance_voter_participation",
        "become_delegator"
        {
          address: current_user.address
        }
      when "send_email"
        {
          email: send_email_verification_input&.email
        }
      when "op_active_debater"
        {
          discourse_verification: ActionTracking::ActionExecutionReadModel.find_by(
            user_id: context[:current_user]&.user_id,
            action_id: ActionTracking::ActionReadModel.find_by(action_type: "discourse_verification")&.action_id
          )
        }
      else
        {}
      end

      result = ActionTracking::ActionExecutionService.start(
        quest_id: quest_id,
        action_id: action_id,
        user_id: context[:current_user]&.user_id,
        start_data: start_data,
        action_type: action_type
      )

      if result.is_a?(ActionTracking::ActionExecutionReadModel)
        {action_execution: result, errors: []}
      else
        {action_execution: nil, errors: [result[:error]]}
      end
    end
  end
end
