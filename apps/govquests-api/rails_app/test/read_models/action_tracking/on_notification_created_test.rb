require "test_helper"

module Notifications
  class OnNotificationCreatedTest < InMemoryTestCase
    def setup
      @handler = OnNotificationCreated.new
      @notification_id = SecureRandom.uuid
      @template_id = SecureRandom.uuid
      @user_id = SecureRandom.uuid
      @channel = "email"
      @priority = 3
      @content = "You have a new message."
      @notification_type = "email_notification"
    end

    test "creates a new notification when handling NotificationCreated event" do
      event = Notifications::NotificationCreated.new(data: {
        notification_id: @notification_id,
        template_id: @template_id,
        user_id: @user_id,
        channel: @channel,
        priority: @priority,
        content: @content,
        notification_type: @notification_type
      })

      assert_difference "Notifications::NotificationReadModel.count", 1 do
        @handler.call(event)
      end

      notification = Notifications::NotificationReadModel.find_by(notification_id: @notification_id)
      assert_equal @template_id, notification.template_id
      assert_equal @user_id, notification.user_id
      assert_equal @channel, notification.channel
      assert_equal @priority, notification.priority
      assert_equal @content, notification.content
      assert_equal "created", notification.status
      assert_equal @notification_type, notification.notification_type
    end
  end
end
