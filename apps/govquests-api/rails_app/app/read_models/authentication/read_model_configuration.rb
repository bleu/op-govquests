module Authentication
  class UserReadModel < ApplicationRecord
    self.table_name = "users"

    validates :user_id, presence: true, uniqueness: true
    validates :address, presence: true, uniqueness: true
    validates :user_type, presence: true, inclusion: {in: %w[delegate non_delegate]}

    has_many :sessions, class_name: "Authentication::SessionReadModel", foreign_key: :user_id
  end

  class SessionReadModel < ApplicationRecord
    self.table_name = "user_sessions"

    belongs_to :user, class_name: "Authentication::UserReadModel", foreign_key: :user_id, primary_key: :user_id

    validates :session_token, presence: true, uniqueness: true
    validates :logged_in_at, presence: true
  end

  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnUserRegistered.new, to: [Authentication::UserRegistered])
      event_store.subscribe(OnUserLoggedIn.new, to: [Authentication::UserLoggedIn])
    end
  end
end
