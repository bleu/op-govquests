# app/models/user.rb
module Authentication
  class User
    include AggregateRoot

    AlreadyRegistered = Class.new(StandardError)

    def initialize(id)
      @id = id
      @email = nil
      @user_type = "non_delegate"
      @address = nil
      @chain_id = nil
      @settings = {}
      @wallets = []
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

    def connect_wallet(wallet_address, chain_id)
      apply WalletConnected.new(data: {
        user_id: @id,
        wallet_address: wallet_address,
        chain_id: chain_id
      })
    end

    def log_in(session_token, timestamp)
      apply UserLoggedIn.new(data: {
        user_id: @id,
        session_token: session_token,
        timestamp: timestamp
      })
    end

    def log_out(session_token)
      apply UserLoggedOut.new(data: {
        user_id: @id,
        session_token: session_token
      })
    end

    def expire_session(session_token, expired_at)
      apply SessionExpired.new(data: {
        user_id: @id,
        session_token: session_token,
        expired_at: expired_at
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

    on WalletConnected do |event|
      @wallets << {
        wallet_address: event.data[:wallet_address],
        chain_id: event.data[:chain_id]
      }
    end

    on UserLoggedIn do |event|
      @sessions << {
        session_token: event.data[:session_token],
        timestamp: event.data[:timestamp]
      }
    end

    on UserLoggedOut do |event|
      @sessions.reject! { |s| s[:session_token] == event.data[:session_token] }
    end

    on SessionExpired do |event|
      @sessions.reject! { |s| s[:session_token] == event.data[:session_token] }
    end
  end
end
