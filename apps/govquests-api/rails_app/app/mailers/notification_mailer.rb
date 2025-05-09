class NotificationMailer < ApplicationMailer
  def notify(notification_id)
    @notification = Notifications::NotificationReadModel.find_by(notification_id: notification_id)
    @user = Authentication::UserReadModel.find_by(user_id: @notification.user_id)

    return unless @user.email.present? && @user.email_notifications

    mail(
      to: @user.email,
      subject: @notification.title
    )
  end
end
