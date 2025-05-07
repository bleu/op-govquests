module Mutations
  class UpdateNotificationPreferences < BaseMutation
    argument :telegram_notifications, Boolean, required: false
    argument :email_notifications, Boolean, required: false

    field :errors, [String], null: false

    def resolve(telegram_notifications: nil, email_notifications: nil)
      user = context[:current_user]

      update_params = {}
      update_params[:telegram_notifications] = telegram_notifications if !telegram_notifications.nil?
      update_params[:email_notifications] = email_notifications if !email_notifications.nil?

      user.update(update_params)

      {errors: []}
    end
  end
end
