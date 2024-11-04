module Authentication
  class SessionReadModel < ApplicationRecord
    self.table_name = "user_sessions"

    belongs_to :user, class_name: "Authentication::UserReadModel", foreign_key: :user_id, primary_key: :user_id

    validates :session_token, presence: true, uniqueness: true
    validates :logged_in_at, presence: true
  end
end

# == Schema Information
#
# Table name: user_sessions
#
#  id            :bigint           not null, primary key
#  logged_in_at  :datetime         not null
#  logged_out_at :datetime
#  session_token :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :string           not null
#
# Indexes
#
#  index_user_sessions_on_user_id  (user_id)
#
