module Authentication
  class RegisterUser < Infra::Command
    attribute :user_id, Infra::Types::UUID
    attribute :email, Infra::Types::String.optional
    attribute :user_type, Infra::Types::String
    attribute :address, Infra::Types::String
    attribute :chain_id, Infra::Types::Integer

    alias_method :aggregate_id, :user_id
  end

  class LogIn < Infra::Command
    attribute :user_id, Infra::Types::UUID
    attribute :session_token, Infra::Types::String
    attribute :timestamp, Infra::Types::Time

    alias_method :aggregate_id, :user_id
  end

  class UpdateUserTelegramToken < Infra::Command
    attribute :user_id, Infra::Types::UUID
    attribute :telegram_token, Infra::Types::String

    alias_method :aggregate_id, :user_id
  end

  class UpdateUserNotificationPreferences < Infra::Command
    attribute :user_id, Infra::Types::UUID
    attribute :telegram_notifications, Infra::Types::Bool.optional
    attribute :email_notifications, Infra::Types::Bool.optional

    alias_method :aggregate_id, :user_id
  end

  class SendEmailVerification < Infra::Command
    attribute :user_id, Infra::Types::UUID
    attribute :email, Infra::Types::String
    attribute :token, Infra::Types::String

    alias_method :aggregate_id, :user_id
  end

  class VerifyEmail < Infra::Command
    attribute :user_id, Infra::Types::UUID

    alias_method :aggregate_id, :user_id
  end

  class UpdateUserType < Infra::Command
    attribute :user_id, Infra::Types::UUID
    attribute :user_type, Infra::Types::String

    alias_method :aggregate_id, :user_id
  end
end

