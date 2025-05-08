module Mutations
  class UpdateNotificationPreferences < BaseMutation
    argument :telegram_notifications, Boolean, required: false
    argument :email_notifications, Boolean, required: false

    field :errors, [String], null: false

    def resolve(telegram_notifications: nil, email_notifications: nil)
      user = context[:current_user]

      command = Authentication::UpdateUserNotificationPreferences.new(
        user_id: user.user_id,
        telegram_notifications: telegram_notifications,
        email_notifications: email_notifications
      )

      Rails.configuration.command_bus.call(command)

      {errors: []}
    end
  end
end
