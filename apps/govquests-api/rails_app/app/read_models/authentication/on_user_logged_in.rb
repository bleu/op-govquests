module Authentication
  class OnUserLoggedIn
    def call(event)
      user_id = event.data.fetch(:user_id)
      session_token = event.data.fetch(:session_token)
      timestamp = event.data.fetch(:timestamp)

      SessionReadModel.find_or_initialize_by(
        user_id: user_id,
        session_token: session_token,
        logged_in_at: timestamp,
        logged_out_at: nil
      ).save!
    end
  end
end
