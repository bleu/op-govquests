require "rails_helper"

RSpec.describe ActionTracking::OnActionCreated, type: :model do
  let(:handler) { described_class.new }
  let(:action_id) { SecureRandom.uuid }
  let(:event) do
    ActionTracking::ActionCreated.new(data: {
      action_id: action_id,
      action_type: "test_type",
      action_data: {foo: "bar"},
      display_data: {title: "Test content"}
    })
  end

  describe "#call" do
    it "creates a new ActionReadModel record" do
      expect {
        handler.call(event)
      }.to change(ActionTracking::ActionReadModel, :count).by(1)

      action = ActionTracking::ActionReadModel.last
      expect(action).to have_attributes(
        action_id: action_id,
        action_type: "test_type",
        action_data: {"foo" => "bar"},
        display_data: {"title" => "Test content"}
      )
    end
  end
end
