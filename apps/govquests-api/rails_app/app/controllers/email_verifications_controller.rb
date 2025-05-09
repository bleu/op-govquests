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

    Authentication::UserReadModel.find_by(user_id: action_execution.user_id).update(email: action_execution.start_data["email"])

    quest_slug = Questing::QuestReadModel.find_by(quest_id: action_execution.quest_id)&.slug

    frontend_domain = Rails.application.credentials.dig(Rails.env.to_sym, :frontend_domain)
    redirect_to "#{frontend_domain}/quests/#{quest_slug}?actionId=#{action_execution.action_id}&result=#{result_str}", allow_other_host: true
  end
end
