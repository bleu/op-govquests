class ActionExecutionsController < ApplicationController
  def start
    action_execution = ActionTracking::ActionExecutionService.start(
      action_id: params[:action_id],
      # TODO: user_id will be removed once we derive the user from the session
      user_id: current_user.user_id,
      start_data: params[:start_data]&.to_unsafe_h || {}
    )

    if action_execution[:error]
      render json: {error: action_execution[:error]}, status: :not_found
    else
      render json: ActionExecutionBlueprint.render(action_execution)
    end
  end

  def complete
    action_execution = ActionTracking::ActionExecutionService.complete(
      execution_id: params[:execution_id],
      nonce: params[:nonce],
      # TODO: user_id will be removed once we derive the user from the session
      user_id: current_user.user_id,
      completion_data: params[:completion_data]&.to_unsafe_h || {}
    )

    if action_execution[:error]
      render json: {error: action_execution[:error]}, status: :unprocessable_entity
    else
      render json: ActionExecutionBlueprint.render(action_execution)
    end
  end
end
