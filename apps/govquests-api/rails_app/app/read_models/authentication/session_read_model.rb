module Authentication
  class SessionReadModel < ApplicationRecord
    self.table_name = "user_sessions"

    belongs_to :user, class_name: "Authentication::UserReadModel", foreign_key: :user_id, primary_key: :user_id

    validates :session_token, presence: true, uniqueness: true
    validates :logged_in_at, presence: true
  end
end
