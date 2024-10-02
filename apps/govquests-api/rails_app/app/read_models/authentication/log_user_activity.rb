module ClientAuthentication
  class LogUserActivity
    def call(event)
      user_id = event.data.fetch(:user_id)
      action_type = event.data.fetch(:action_type)
      action_timestamp = event.data.fetch(:action_timestamp)

      user = User.find_by(user_id: user_id)
      if user
        user.activities ||= []
        user.activities << {action_type: action_type, timestamp: action_timestamp}
        user.save
      end
    end
  end
end
