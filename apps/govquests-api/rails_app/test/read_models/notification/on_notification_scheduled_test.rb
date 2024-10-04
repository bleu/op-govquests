require "test_helper"

module Notifications
  class OnNotificationScheduledTest < ActiveSupport::TestCase
    def setup
      @handler = OnNotificationScheduled.new
      @notification_id = SecureRandom.uuid
      @scheduled_time = Time.current + 1.day

      NotificationReadModel.create!(
        notification_id: @notification_id,
        template_id: SecureRandom.uuid,
        user_id: SecureRandom.uuid,
        channel: "email",
        priority: 2,
        content: "Your weekly summary is ready.",
        notification_type: "summary",
        status: "created"
      )
    end

    test "schedules a notification when handling NotificationScheduled event" do
      event = NotificationScheduled.new(data: {
        notification_id: @notification_id,
        scheduled_time: @scheduled_time
      })

      @handler.call(event)

      notification = NotificationReadModel.find_by(notification_id: @notification_id)
      assert_equal @scheduled_time.to_i, notification.scheduled_time.to_i
      assert_equal "scheduled", notification.status
    end
  end
end
