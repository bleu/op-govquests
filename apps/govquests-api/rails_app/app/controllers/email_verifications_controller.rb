# frozen_string_literal: true

class EmailVerificationsController < ApplicationController
  def verify
    return render json: {error: "Invalid token"}, status: :not_found unless params[:token]

    token = params[:token]

    user = Authentication::UserReadModel.find_by(email_verification_token: token)

    if user.nil?
      return render json: {error: "Invalid token"}, status: :not_found
    end

    user.update(email: user.email, email_verification_token: nil)

    frontend_domain = Rails.application.credentials.dig(Rails.env.to_sym, :frontend_domain)
    redirect_to "#{frontend_domain}/?showNotificationSettings=true", allow_other_host: true
  end
end
