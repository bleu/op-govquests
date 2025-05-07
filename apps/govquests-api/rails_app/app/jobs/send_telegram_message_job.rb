require "telegram/bot"

class SendTelegramMessageJob < ApplicationJob
  queue_as :default

  class << self
    def bot
      @bot ||= Telegram::Bot::Client.new(Rails.application.credentials.telegram_bot.token)
    end
  end

  def perform(notification_id)
    notification = Notifications::NotificationReadModel.find_by(notification_id:)
    user = Authentication::UserReadModel.find_by(user_id: notification.user_id)

    return unless user.telegram_chat_id.present? && user.telegram_notifications

    self.class.bot.api.send_message(
      chat_id: user.telegram_chat_id,
      text: notification.content
    )
  rescue => e
    Rails.logger.error("Failed to send Telegram message: #{e.message}")
    raise e
  end
end
