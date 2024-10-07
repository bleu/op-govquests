# spec/read_models/notifications/on_notification_scheduled_spec.rb
require "rails_helper"

RSpec.describe Notifications::OnNotificationScheduled do
  let(:handler) { described_class.new }
  let(:notification_id) { SecureRandom.uuid }
  let(:scheduled_time) { Time.current + 1.day }

  before do
    Notifications::NotificationReadModel.create!(
      notification_id: notification_id,
      template_id: SecureRandom.uuid,
      user_id: SecureRandom.uuid,
      channel: "email",
      priority: 2,
      content: "Your weekly summary is ready.",
      notification_type: "summary",
      status: "created"
    )
  end

  describe "#call" do
    it "schedules a notification when handling NotificationScheduled event" do
      event = Notifications::NotificationScheduled.new(data: {
        notification_id: notification_id,
        scheduled_time: scheduled_time
      })

      handler.call(event)

      notification = Notifications::NotificationReadModel.find_by(notification_id: notification_id)
      expect(notification.scheduled_time.to_i).to eq(scheduled_time.to_i)
      expect(notification.status).to eq("scheduled")
    end
  end
end
