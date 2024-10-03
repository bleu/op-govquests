require_relative "test_helper"

module Notifications
  class NotificationTest < Test
    cover "Notifications::Notification"

    def setup
      super
      @notification_id = SecureRandom.uuid
      @notification = Notification.new(@notification_id)
    end

    def test_create_a_new_notification
      user_id = SecureRandom.uuid
      content = "You've earned a badge!"
      type = "tier_achieved"

      @notification.create(user_id, content, type)

      events = @notification.unpublished_events.to_a
      assert_equal 1, events.size
      event = events.first
      assert_instance_of NotificationCreated, event
      assert_equal @notification_id, event.data[:notification_id]
      assert_equal user_id, event.data[:user_id]
      assert_equal content, event.data[:content]
      assert_equal type, event.data[:notification_type]
    end

    def test_send_a_notification
      @notification.create(SecureRandom.uuid, "Test content", "test")

      @notification.send_notification

      events = @notification.unpublished_events.to_a
      assert_equal 2, events.size
      event = events.last
      assert_instance_of NotificationSent, event
      assert_equal @notification_id, event.data[:notification_id]
      assert_instance_of Time, event.data[:sent_at]
    end

    def test_mark_notification_as_read
      @notification.create(SecureRandom.uuid, "Test content", "test")
      @notification.send_notification

      @notification.mark_as_read

      events = @notification.unpublished_events.to_a
      assert_equal 3, events.size
      event = events.last
      assert_instance_of NotificationMarkedAsRead, event
      assert_equal @notification_id, event.data[:notification_id]
      assert_instance_of Time, event.data[:read_at]
    end
  end
end
