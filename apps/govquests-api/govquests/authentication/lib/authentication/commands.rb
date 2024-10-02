module Authentication
  class RegisterUser < Infra::Command
    attribute :user_id, Infra::Types::UUID
    attribute :address, Infra::Types::String
    attribute :chain_id, Infra::Types::Integer
    attribute :email, Infra::Types::String.optional
    attribute :user_type, Infra::Types::String

    alias_method :aggregate_id, :user_id
  end

  class LogIn < Infra::Command
    attribute :user_id, Infra::Types::UUID
    attribute :session_token, Infra::Types::String
    attribute :timestamp, Infra::Types::Time

    alias_method :aggregate_id, :user_id
  end
end
