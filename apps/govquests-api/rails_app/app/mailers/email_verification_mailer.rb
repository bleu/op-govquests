class EmailVerificationMailer < ApplicationMailer
  def verify_email
    @email = params[:email]
    @token = params[:token]

    domain_url = Rails.application.credentials.dig(Rails.env.to_sym, :backend_domain)

    @verification_link = "#{domain_url}/email_verifications/verify?token=#{@token}"

    mail(
      to: @email, subject: "GovQuests - verify your email"
    )
  end
end
