module Authentication
  class OnUserNotificationPreferencesUpdated
    def call(event)
      user = UserReadModel.find_by(user_id: event.data[:user_id])

      telegram_notifications = event.data[:telegram_notifications]
      email_notifications = event.data[:email_notifications]

      update_params = {}
      update_params[:telegram_notifications] = telegram_notifications if !telegram_notifications.nil?
      update_params[:email_notifications] = email_notifications if !email_notifications.nil?

      user.update(update_params)
    end
  end
end
