class ActionCompletionsController < ApplicationController
  def start
    action = ActionTracking::ActionReadModel.find_by(action_id: params[:action_id])
    if action
      token = generate_completion_token(action.action_id)
      render json: { token: token, expires_at: 30.minutes.from_now }
    else
      render json: { error: "Action not found" }, status: :not_found
    end
  end

  def complete
    action = ActionTracking::ActionReadModel.find_by(action_id: params[:action_id])
    if action && valid_completion_token?(params[:token], action.action_id)
      command = ActionTracking::CompleteAction.new(
        action_id: action.action_id,
        user_id: current_user.id,
        completion_data: params[:completion_data]
      )
      Rails.configuration.command_bus.call(command)
      render json: { message: "Action completed successfully" }
    else
      render json: { error: "Invalid completion attempt" }, status: :unprocessable_entity
    end
  end

  private

  def generate_completion_token(action_id)
    expiration = 30.minutes.from_now.to_i
    payload = {
      action_id: action_id,
      user_id: current_user.id,
      exp: expiration
    }
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  def valid_completion_token?(token, action_id)
    decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base)
    payload = decoded_token.first
    payload["action_id"] == action_id &&
      payload["user_id"] == current_user.id &&
      Time.at(payload["exp"]) > Time.now
  rescue JWT::DecodeError
    false
  end
end
