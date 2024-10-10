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
  end
end
