class ActionExecutionsController < ApplicationController
  def start
    result = ActionTracking::ActionExecutionService.start(
      action_id: params[:action_id],
      # TODO: user_id will be removed once we derive the user from the session
      user_id: params[:user_id],
      start_data: params[:start_data]&.to_unsafe_h || {}
    )

    if result[:error]
      render json: {error: result[:error]}, status: :not_found
    else
      render json: result
    end
  end

  def complete
    result = ActionTracking::ActionExecutionService.complete(
      execution_id: params[:execution_id],
      nonce: params[:nonce],
      # TODO: user_id will be removed once we derive the user from the session
      user_id: params[:user_id],
      completion_data: params[:completion_data]&.to_unsafe_h || {}
    )

    if result[:error]
      render json: {error: result[:error]}, status: :unprocessable_entity
    else
      render json: result
    end
  end
end
