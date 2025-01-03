# frozen_string_literal: true

class EmailVerificationsController < ApplicationController
  def verify
    return render json: {error: "Invalid token"}, status: :not_found unless params[:token]

    token = params[:token]

    action_execution = ActionTracking::ActionExecutionReadModel.where("start_data ->> 'token' = ?", token).first

    result = ActionTracking::ActionExecutionService.complete(
      execution_id: action_execution.execution_id,
      nonce: action_execution.nonce,
      user_id: action_execution.user_id,
      completion_data: {
        token:
      },
      action_type: action_execution.action_type
    )

    result_str = result[:error] ? "error" : "success"
    # TODO: return errors when they happen

    redirect_to "http://localhost:3000/quests/#{action_execution.quest_id}?result=#{result_str}"
  end
end
