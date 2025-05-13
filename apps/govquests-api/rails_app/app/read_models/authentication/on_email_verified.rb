module Authentication
  class OnEmailVerified
    def call(event)
      user = Authentication::UserReadModel.find_by(user_id: event.data[:user_id])

      user.update(
        email_verification_status: event.data[:status],
        email_notifications: true
      )
    end
  end
end
