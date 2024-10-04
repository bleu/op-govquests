module Authentication
  class UserReadModel < ApplicationRecord
    self.table_name = "users"

    validates :user_id, presence: true, uniqueness: true
    validates :email, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP}
    validates :user_type, presence: true, inclusion: {in: %w[delegate non_delegate]}
  end

  class SessionReadModel < ApplicationRecord
    self.table_name = "user_sessions"

    validates :user_id, presence: true
    validates :session_token, presence: true, uniqueness: true
    validates :logged_in_at, presence: true
    # logged_out_at can be nil for active sessions
  end

  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnUserRegistered.new, to: [Authentication::UserRegistered])
      event_store.subscribe(OnUserLoggedIn.new, to: [Authentication::UserLoggedIn])
    end
  end
end
