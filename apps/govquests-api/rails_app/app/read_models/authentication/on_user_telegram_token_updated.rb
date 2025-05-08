module Authentication
  class OnUserTelegramTokenUpdated
    def call(event)
      user = UserReadModel.find_by(user_id: event.data[:user_id])

      user.update(telegram_token: event.data[:telegram_token])
    end
  end
end
