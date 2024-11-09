RSpec.describe Processes::DeliverNotificationOnCreated do
  let(:event_store) { Infra::EventStore.in_memory }
  let(:command_bus) { FakeCommandBus.new }
  let(:process) { described_class.new(event_store, command_bus) }

  before do
    process.subscribe
  end

  describe "#call" do
    it "dispatches delivery commands for each method" do
      event = Notifications::NotificationCreated.new(data: {
        notification_id: SecureRandom.uuid,
        user_id: SecureRandom.uuid,
        content: "Test",
        notification_type: "test",
        delivery_methods: ["in_app", "email", "sms"]
      })

      event_store.publish(event)

      expect(command_bus.all_received.size).to eq(3)
      expect(command_bus.all_received.map(&:delivery_method)).to eq(["in_app", "email", "sms"])
    end
  end
end
