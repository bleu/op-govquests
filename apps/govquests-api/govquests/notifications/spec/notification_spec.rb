require "spec_helper"

RSpec.describe Notifications::Notification do
  let(:notification_id) { SecureRandom.uuid }
  let(:notification) { described_class.new(notification_id) }

  describe "#create" do
    context "when creating a new notification" do
      it "creates a NotificationCreated event with correct data" do
        user_id = SecureRandom.uuid
        content = "You've earned a badge!"
        type = "tier_achieved"

        notification.create(user_id, content, type)
        events = notification.unpublished_events.to_a

        expect(events.size).to eq(1)
        event = events.first

        expect(event).to be_a(Notifications::NotificationCreated)
        expect(event.data[:notification_id]).to eq(notification_id)
        expect(event.data[:user_id]).to eq(user_id)
        expect(event.data[:content]).to eq(content)
        expect(event.data[:notification_type]).to eq(type)
      end
    end
  end

  describe "#send_notification" do
    context "when sending a notification" do
      it "creates a NotificationSent event with correct data" do
        user_id = SecureRandom.uuid
        content = "Test content"
        type = "test"

        notification.create(user_id, content, type)
        notification.send_notification
        events = notification.unpublished_events.to_a

        expect(events.size).to eq(2)
        event = events.last

        expect(event).to be_a(Notifications::NotificationSent)
        expect(event.data[:notification_id]).to eq(notification_id)
        expect(event.data[:sent_at]).to be_a(Time)
      end
    end
  end

  describe "#mark_as_read" do
    context "when marking a notification as read" do
      it "creates a NotificationMarkedAsRead event with correct data" do
        user_id = SecureRandom.uuid
        content = "Test content"
        type = "test"

        notification.create(user_id, content, type)
        notification.send_notification
        notification.mark_as_read
        events = notification.unpublished_events.to_a

        expect(events.size).to eq(3)
        event = events.last

        expect(event).to be_a(Notifications::NotificationMarkedAsRead)
        expect(event.data[:notification_id]).to eq(notification_id)
        expect(event.data[:read_at]).to be_a(Time)
      end
    end

    context "when marking as read before sending" do
      it "creates a NotificationMarkedAsRead event even if not sent" do
        user_id = SecureRandom.uuid
        content = "Test content"
        type = "test"

        notification.create(user_id, content, type)
        notification.mark_as_read
        events = notification.unpublished_events.to_a

        expect(events.size).to eq(2)
        event = events.last

        expect(event).to be_a(Notifications::NotificationMarkedAsRead)
      end
    end
  end

  describe "state changes" do
    it "updates sent_at and read_at timestamps appropriately" do
      user_id = SecureRandom.uuid
      content = "Test content"
      type = "test"

      notification.create(user_id, content, type)
      expect(notification.instance_variable_get(:@sent_at)).to be_nil
      expect(notification.instance_variable_get(:@read_at)).to be_nil

      notification.send_notification
      expect(notification.instance_variable_get(:@sent_at)).to be_a(Time)

      notification.mark_as_read
      expect(notification.instance_variable_get(:@read_at)).to be_a(Time)
    end
  end
end
