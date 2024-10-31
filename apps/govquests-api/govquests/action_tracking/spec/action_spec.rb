require "spec_helper"

RSpec.describe ActionTracking::Action do
  let(:action_id) { SecureRandom.uuid }
  let(:action) { described_class.new(action_id) }

  let(:valid_action_data) {
    {
      action_type: "read_document",
      action_data: {
        "url" => "https://example.com/document",
        "required_time" => 300
      },
      display_data: {
        "title" => "Read Documentation",
        "description" => "Read through the getting started guide"
      }
    }
  }

  describe "#create" do
    context "when creating with valid data" do
      it "emits ActionCreated event with correct data" do
        action.create(
          valid_action_data[:action_type],
          valid_action_data[:action_data],
          valid_action_data[:display_data]
        )

        expect(action.unpublished_events.size).to eq(1)
        event = action.unpublished_events.first

        expect(event).to be_a(ActionTracking::ActionCreated)
        expect(event.data[:action_id]).to eq(action_id)
        expect(event.data[:action_type]).to eq(valid_action_data[:action_type])
        expect(event.data[:action_data]).to eq(valid_action_data[:action_data])
        expect(event.data[:display_data]).to eq(valid_action_data[:display_data])
      end

      it "updates internal state correctly" do
        action.create(
          valid_action_data[:action_type],
          valid_action_data[:action_data],
          valid_action_data[:display_data]
        )

        expect(action.instance_variable_get(:@state)).to eq("created")
        expect(action.instance_variable_get(:@action_type)).to eq(valid_action_data[:action_type])
        expect(action.instance_variable_get(:@action_data)).to eq(valid_action_data[:action_data])
        expect(action.instance_variable_get(:@display_data)).to eq(valid_action_data[:display_data])
      end
    end

    context "when creating an already created action" do
      it "raises AlreadyCreatedError" do
        action.create(
          valid_action_data[:action_type],
          valid_action_data[:action_data],
          valid_action_data[:display_data]
        )

        expect {
          action.create(
            valid_action_data[:action_type],
            valid_action_data[:action_data],
            valid_action_data[:display_data]
          )
        }.to raise_error(ActionTracking::Action::AlreadyCreatedError)
      end
    end
  end
end
