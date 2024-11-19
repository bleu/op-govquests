module ActionTracking
  class VerifyEmailClient
    def self.send_email_async(email, token)
      # TODO: deliver_later
      ::EmailVerificationMailer.with(email: email, token: token).verify_email.deliver_now
    end
  end
end
