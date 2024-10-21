module Mutations
  class StartActionExecution < BaseMutation
    argument :quest_id, ID, required: true
    argument :action_id, ID, required: true
    argument :action_type, String, required: true, description: "Type of the action"

    field :action_execution, Types::ActionExecutionType, null: true
    field :errors, [String], null: false

    def resolve(quest_id:, action_id:, action_type:)
      action = ActionTracking::ActionReadModel.find_by(action_id: action_id)
      unless action
        return {action_execution: nil, errors: ["Action not found"]}
      end

      start_data = case action_type
      when "ens"
        ens_start_data&.to_h || {
          address: current_user.address
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
