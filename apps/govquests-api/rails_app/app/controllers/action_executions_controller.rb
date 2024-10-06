class ActionExecutionsController < ApplicationController
  def start
    result = ActionTracking::ActionExecutionService.start(
      action_id: params[:action_id],
      # TODO: user_id will be removed once we derive the user from the session
      user_id: params[:user_id],
      data: params[:data]&.to_unsafe_h || {}
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
      salt: params[:salt],
      # TODO: user_id will be removed once we derive the user from the session
      user_id: params[:user_id],
      data: params[:data]&.to_unsafe_h || {}
    )

    if result[:error]
      render json: {error: result[:error]}, status: :unprocessable_entity
    else
      render json: result
    end
  end
end
