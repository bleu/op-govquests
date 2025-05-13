module Authentication
  class OnTelegramAccountConnected
    def call(event)
      user = Authentication::UserReadModel.find_by(user_id: event.data[:user_id])

      user.update(
        telegram_chat_id: event.data[:chat_id],
        telegram_notifications: true
      )
    end
  end
end
