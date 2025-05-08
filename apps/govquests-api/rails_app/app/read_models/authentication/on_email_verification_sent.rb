module Authentication
  class OnEmailVerificationSent
    def call(event)
      user = Authentication::UserReadModel.find_by(user_id: event.data[:user_id])

      user.update(
        email_verification_token: event.data[:token],
        email: event.data[:email],
        pending_email_verification: true
      )
    end
  end
end
