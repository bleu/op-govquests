require "rails_helper"

RSpec.describe ActionTracking::OnActionCreated do
  describe "#call" do
    it "creates action read model on ActionCreated event" do
      id = SecureRandom.uuid
      event = ActionTracking::ActionCreated.new(data: {
        action_id: id,
        action_type: "test_type",
        action_data: {foo: "bar"},
        display_data: {title: "Test content"}
      })

      expect {
        described_class.new.call(event)
      }.to change(ActionTracking::ActionReadModel, :count).by(1)

      action = ActionTracking::ActionReadModel.last
      expect(action.action_id).to eq(id)
      expect(action.action_type).to eq("test_type")
      expect(action.action_data).to eq({"foo" => "bar"})
      expect(action.display_data).to eq({"title" => "Test content"})
    end
  end
end
