require "infra"
require_relative "authentication/commands"
require_relative "authentication/events"

require_relative "authentication/user"

AUTHENTICATION_NAMESPACE_UUID = "c879634b-ba00-48c5-8ac1-820e3d4cd90c".freeze

module Authentication
  class << self
    def generate_user_id(address, chain_id)
      name = "Address$#{address}-ChainId$#{chain_id}"
      namespace_uuid = AUTHENTICATION_NAMESPACE_UUID
      Digest::UUID.uuid_v5(namespace_uuid, name)
    end
  end

  class Configuration
    def call(event_store, command_bus)
      CommandHandler.register_commands(event_store, command_bus)
    end
  end

  class CommandHandler < Infra::CommandHandlerRegistry
    handle "Authentication::RegisterUser", aggregate: User do |user, cmd|
      user.register(
        cmd.email,
        cmd.user_type,
        cmd.address,
        cmd.chain_id
      )
    end

    handle "Authentication::LogIn", aggregate: User do |user, cmd|
      user.log_in(
        cmd.session_token,
        cmd.timestamp
      )
    end

    handle "Authentication::UpdateUserTelegramToken", aggregate: User do |user, cmd|
      user.update_telegram_token(
        cmd.telegram_token
      )
    end

    handle "Authentication::UpdateUserNotificationPreferences", aggregate: User do |user, cmd|
      user.update_notification_preferences(
        cmd.telegram_notifications,
        cmd.email_notifications
      )
    end

    handle "Authentication::SendEmailVerification", aggregate: User do |user, cmd|
      user.send_email_verification(
        cmd.email,
        cmd.token
      )
    end

    handle "Authentication::VerifyEmail", aggregate: User do |user, cmd|
      user.verify_email
    end

    handle "Authentication::ConnectTelegramAccount", aggregate: User do |user, cmd|
      user.connect_telegram_account(
        cmd.chat_id
      )
    end
  end
end
