class ActionCompletionsController < ApplicationController
  def start
    action = ActionTracking::ActionReadModel.find_by(action_id: params[:action_id])
    if action
      execution_id = SecureRandom.uuid
      token = generate_completion_token(execution_id)
      command = ActionTracking::StartActionExecution.new(
        execution_id: execution_id,
        action_id: action.action_id,
        user_id: params[:user_id],
        data: params[:start_data].to_unsafe_h # This allows unpermitted parameters
      )
      Rails.configuration.command_bus.call(command)
      render json: {token: token, execution_id: execution_id, expires_at: 30.minutes.from_now}
    else
      render json: {error: "Action not found"}, status: :not_found
    end
  end

  def complete
    execution = ActionTracking::ActionExecutionReadModel.find_by(execution_id: params[:execution_id])
    if execution && valid_completion_token?(params[:token], execution.execution_id)
      command = ActionTracking::CompleteActionExecution.new(
        execution_id: execution.execution_id,
        data: params[:completion_data]
      )
      Rails.configuration.command_bus.call(command)
      render json: {message: "Action completed successfully"}
    else
      render json: {error: "Invalid completion attempt"}, status: :unprocessable_entity
    end
  end

  private

  def generate_completion_token(execution_id)
    expiration = 30.minutes.from_now.to_i
    payload = {
      execution_id: execution_id,
      user_id: params[:user_id],
      exp: expiration
    }
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end

  def valid_completion_token?(token, execution_id)
    decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base)
    payload = decoded_token.first
    payload["execution_id"] == execution_id &&
      payload["user_id"] == current_user.id &&
      Time.at(payload["exp"]) > Time.now
  rescue JWT::DecodeError
    false
  end
end
