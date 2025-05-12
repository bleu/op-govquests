require "telegram/bot"

class SendTelegramMessageJob < ApplicationJob
  queue_as :default

  class << self
    def bot
      @bot ||= Telegram::Bot::Client.new(Rails.application.credentials.telegram_bot.dig(Rails.env.to_sym, :token))
    end
  end

  def perform(notification_id)
    notification = Notifications::NotificationReadModel.find_by(notification_id:)
    user = Authentication::UserReadModel.find_by(user_id: notification.user_id)

    return unless user.telegram_chat_id.present? && user.telegram_notifications

    message_params = {
      chat_id: user.telegram_chat_id,
      text: "<b>#{notification.title}</b>\n\n#{notification.content}",
      parse_mode: "HTML"
    }

    if notification.cta_text.present? && notification.cta_url.present? && Rails.env.production?
      message_params[:reply_markup] = Telegram::Bot::Types::InlineKeyboardMarkup.new(
        inline_keyboard: [
          [
            Telegram::Bot::Types::InlineKeyboardButton.new(
              text: notification.cta_text,
              url: notification.cta_url
            )
          ]
        ]
      )
    end

    self.class.bot.api.send_message(message_params)
  rescue => e
    Rails.logger.error("Failed to send Telegram message: #{e.message}")
    raise e
  end
end
