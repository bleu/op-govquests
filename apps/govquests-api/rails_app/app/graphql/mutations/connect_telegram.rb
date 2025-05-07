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
      user.update(telegram_token: telegram_token)

      {
        link_to_chat: "https://t.me/#{Rails.application.credentials.telegram_bot.username}?start=#{telegram_token}",
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
