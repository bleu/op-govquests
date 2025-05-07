class TelegramBotServer
  def initialize
    @token = Rails.application.credentials.telegram_bot.token
  end

  def start
    Telegram::Bot::Client.run(@token) do |bot|
      bot.listen do |message|
        case message
        when Telegram::Bot::Types::Message
          if message.text&.start_with?("/start")
            handle_start(bot, message)
          end
        end
      end
    end
  end

  private

  def handle_start(bot, message)
    chat_id = message.chat.id
    telegram_token = message.text.split(" ").last

    if telegram_token.present?
      user = Authentication::UserReadModel.find_by(telegram_token: telegram_token)

      if user.present?
        user.update(telegram_chat_id: chat_id)
        bot.api.send_message(chat_id: chat_id, text: "Successfully connected to your account!")
      else
        bot.api.send_message(chat_id: chat_id, text: "Invalid token")
      end
    end
  end
end
