module Authentication
  class User
    include AggregateRoot

    AlreadyRegistered = Class.new(StandardError)
    SessionNotFound = Class.new(StandardError)
    InvalidSession = Class.new(StandardError)

    def initialize(id)
      @id = id
      @email = nil
      @user_type = "non_delegate"
      @settings = {}
      @address = nil
      @chain_id = nil
      @ens = nil
      @sessions = []
      @quests_progress = {}
      @activity_log = []
      @claimed_rewards = []
      @telegram_token = nil
      @telegram_notifications = false
      @email_notifications = false
    end

    def register(email, user_type, address, chain_id)
      raise AlreadyRegistered if @registered

      apply UserRegistered.new(data: {
        user_id: @id,
        email: email,
        user_type: user_type,
        address: address,
        chain_id: chain_id
      })
    end

    def log_in(session_token, timestamp)
      raise "User not registered" unless @registered

      apply UserLoggedIn.new(data: {
        user_id: @id,
        session_token: session_token,
        timestamp: timestamp
      })
    end

    def update_telegram_token(telegram_token)
      apply UserTelegramTokenUpdated.new(data: {
        user_id: @id,
        telegram_token: telegram_token
      })
    end

    def update_notification_preferences(telegram_notifications, email_notifications)
      apply UserNotificationPreferencesUpdated.new(data: {
        user_id: @id,
        telegram_notifications: telegram_notifications,
        email_notifications: email_notifications
      })
    end

    private

    on UserRegistered do |event|
      @registered = true
      @email = event.data[:email]
      @user_type = event.data[:user_type]
      @address = event.data[:address]
      @chain_id = event.data[:chain_id]
    end

    on UserLoggedIn do |event|
      @sessions << {
        session_token: event.data[:session_token],
        logged_in_at: event.data[:timestamp]
      }
    end

    on UserTelegramTokenUpdated do |event|
      @telegram_token = event.data[:telegram_token]
    end

    on UserNotificationPreferencesUpdated do |event|
      @telegram_notifications = event.data[:telegram_notifications]
      @email_notifications = event.data[:email_notifications]
    end
  end
end
