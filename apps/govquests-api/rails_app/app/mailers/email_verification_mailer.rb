class EmailVerificationMailer < ActionMailer::Base
  default from: "jose@bleu.studio"

  def verify_email
    @email = params[:email]
    @token = params[:token]

    @verification_link = "http://localhost:3001/email_verifications/verify?token=#{@token}"

    mail(
      from: "jose@bleu.studio",
      to: @email, subject: "GovQuests - verify your email"
    )
  end
end
