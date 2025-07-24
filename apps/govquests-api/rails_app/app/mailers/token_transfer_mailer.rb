class TokenTransferMailer < ApplicationMailer
  def request_transfer
    @amount = params[:amount]
    @user_address = params[:user_address]

    administrators_emails = Authentication::UserReadModel.where(is_admin: true).pluck(:email)

    domain_url = Rails.application.credentials.dig(Rails.env.to_sym, :frontend_domain)

    @confirmation_url = "#{domain_url}/confirm-token-transfer?pool-id=#{params[:pool_id]}&user-id=#{params[:user_id]}"

    mail(
      to: administrators_emails,
      subject: "Token Transfer Request"
    )
  end
end
