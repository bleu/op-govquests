module Mutations
  class ConnectTelegram < BaseMutation
    field :link_to_chat, String, null: true
    field :errors, [String], null: false

    def resolve
      user = context[:current_user]

      if user.telegram_chat_id.present?
        return {link_to_chat: nil, errors: ["Telegram already connected"]}
      end

      telegram_token = SecureRandom.hex(16)

      command = Authentication::UpdateUserTelegramToken.new(
        user_id: user.user_id,
        telegram_token: telegram_token
      )

      Rails.configuration.command_bus.call(command)

      {
        link_to_chat: "https://t.me/#{Rails.application.credentials.telegram_bot.dig(Rails.env.to_sym, :username)}?start=#{telegram_token}",
        errors: []
      }
    rescue => e
      {
        link_to_chat: nil,
        errors: [e.message]
      }
    end
  end
end
