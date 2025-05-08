module Authentication
  class OnEmailVerified
    def call(event)
      user = Authentication::UserReadModel.find_by(user_id: event.data[:user_id])

      user.update(
        pending_email_verification: false
      )
    end
  end
end
