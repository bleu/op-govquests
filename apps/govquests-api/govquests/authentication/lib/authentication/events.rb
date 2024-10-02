module Authentication
  class UserRegistered < Infra::Event
    attribute :user_id, Infra::Types::UUID
    attribute :email, Infra::Types::String.optional
    attribute :user_type, Infra::Types::String
  end

  class WalletConnected < Infra::Event
    attribute :user_id, Infra::Types::UUID
    attribute :wallet_address, Infra::Types::String
    attribute :chain_id, Infra::Types::Integer
  end

  class UserLoggedIn < Infra::Event
    attribute :user_id, Infra::Types::UUID
    attribute :session_token, Infra::Types::String
    attribute :timestamp, Infra::Types::Time
  end

  class UserLoggedOut < Infra::Event
    attribute :user_id, Infra::Types::UUID
    attribute :session_token, Infra::Types::String
  end

  class SessionExpired < Infra::Event
    attribute :user_id, Infra::Types::UUID
    attribute :session_token, Infra::Types::String
    attribute :expired_at, Infra::Types::Time
  end
end
