class EmailVerificationMailer < ActionMailer::Base
  default from: "jose@bleu.studio"

  def verify_email
    @email = params[:email]
    @token = params[:token]

    domain_url = Rails.application.credentials.dig(Rails.env.to_sym, :backend_domain)

    @verification_link = "#{domain_url}/email_verifications/verify?token=#{@token}"

    mail(
      from: "jose@bleu.studio",
      to: @email, subject: "GovQuests - verify your email"
    )
  end
end
