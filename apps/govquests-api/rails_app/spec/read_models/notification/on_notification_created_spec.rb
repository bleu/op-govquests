require "rails_helper"

RSpec.describe Notifications::OnNotificationCreated do
  let(:handler) { described_class.new }
  let(:notification_id) { SecureRandom.uuid }
  let(:template_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
  let(:channel) { "email" }
  let(:priority) { 3 }
  let(:content) { "You have a new message." }
  let(:notification_type) { "email_notification" }

  describe "#call" do
    it "creates a new notification when handling NotificationCreated event" do
      event = Notifications::NotificationCreated.new(data: {
        notification_id: notification_id,
        template_id: template_id,
        user_id: user_id,
        channel: channel,
        priority: priority,
        content: content,
        notification_type: notification_type
      })

      expect {
        handler.call(event)
      }.to change(Notifications::NotificationReadModel, :count).by(1)

      notification = Notifications::NotificationReadModel.find_by(notification_id: notification_id)
      expect(notification.template_id).to eq(template_id)
      expect(notification.user_id).to eq(user_id)
      expect(notification.channel).to eq(channel)
      expect(notification.priority).to eq(priority)
      expect(notification.content).to eq(content)
      expect(notification.status).to eq("created")
      expect(notification.notification_type).to eq(notification_type)
    end
  end
end
