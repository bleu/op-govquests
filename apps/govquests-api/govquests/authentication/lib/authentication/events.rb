module Authentication
  class UserRegistered < Infra::Event
    attribute :user_id, Infra::Types::UUID
    attribute :email, Infra::Types::String.optional
    attribute :user_type, Infra::Types::String
    attribute :wallet_address, Infra::Types::String
    attribute :chain_id, Infra::Types::Integer
  end

  class UserLoggedIn < Infra::Event
    attribute :user_id, Infra::Types::UUID
    attribute :session_token, Infra::Types::String
    attribute :timestamp, Infra::Types::Time
  end
end