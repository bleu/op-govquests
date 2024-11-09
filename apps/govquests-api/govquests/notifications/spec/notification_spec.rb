# spec/notifications/notification_spec.rb
require "spec_helper"

RSpec.describe Notifications::Notification do
  let(:notification_id) { SecureRandom.uuid }
  let(:notification) { described_class.new(notification_id) }
  let(:user_id) { SecureRandom.uuid }
  let(:content) { "Test notification" }
  let(:type) { "test" }

  describe "#create" do
    it "creates notification with default in_app delivery" do
      notification.create(user_id, content, type)
      event = notification.unpublished_events.first

      expect(event.data[:delivery_methods]).to eq(["in_app"])
    end

    it "creates notification with specified delivery methods" do
      notification.create(user_id, content, type, ["email", "sms"])
      event = notification.unpublished_events.first

      expect(event.data[:delivery_methods]).to eq(["email", "sms"])
    end
  end

  describe "#deliver" do
    before do
      notification.create(user_id, content, type, ["in_app", "email"])
    end

    it "delivers via in_app" do
      notification.deliver("in_app")
      event = notification.unpublished_events.to_a.last

      expect(event).to be_a(Notifications::NotificationDelivered)
      expect(event.data[:delivery_method]).to eq("in_app")
      expect(event.data[:metadata]).to include(user_id: user_id)
    end

    it "delivers via email" do
      notification.deliver("email")
      event = notification.unpublished_events.to_a.last

      expect(event).to be_a(Notifications::NotificationDelivered)
      expect(event.data[:delivery_method]).to eq("email")
      expect(event.data[:metadata]).to include(to: "user@example.com")
    end

    it "raises error for unknown delivery method" do
      expect {
        notification.deliver("unknown")
      }.to raise_error(Notifications::Delivery::DeliveryStrategyFactory::UnknownDeliveryMethodError)
    end

    it "raises error when delivering same method twice" do
      notification.deliver("in_app")

      expect {
        notification.deliver("in_app")
      }.to raise_error(Notifications::Notification::AlreadyDeliveredError)
    end
  end
end
