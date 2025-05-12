class TelegramBotServer
  def initialize
    @token = Rails.application.credentials.telegram_bot.dig(Rails.env.to_sym, :token)
    @command_bus = Rails.configuration.command_bus
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
        @command_bus.call(Authentication::ConnectTelegramAccount.new(user_id: user.user_id, chat_id: chat_id))

        message_params = {
          chat_id: chat_id,
          text: "🎉 Welcome to GovQuests! Your Telegram account has been successfully connected. You'll now receive notifications about your quests, achievements, and rewards directly here."
        }

        if Rails.env.production?
          message_params[:text] += " Click below to return to the app and start your journey!"
          message_params[:reply_markup] = Telegram::Bot::Types::InlineKeyboardMarkup.new(
            inline_keyboard: [
              [
                Telegram::Bot::Types::InlineKeyboardButton.new(
                  text: "Return to GovQuests",
                  url: Rails.application.credentials.dig(Rails.env.to_sym, :frontend_domain)
                )
              ]
            ]
          )
        end

        bot.api.send_message(message_params)
      else
        bot.api.send_message(chat_id: chat_id, text: "❌ Invalid token. Please make sure you're using the correct connection link from the GovQuests app.")
      end
    end
  end
end
