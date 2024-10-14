require "spec_helper"

RSpec.describe ActionTracking::Action do
  let(:action_id) { SecureRandom.uuid }
  let(:action) { described_class.new(action_id) }

  describe "#create" do
    context "when creating a new action" do
      it "creates an ActionCreated event with correct data" do
        action_type = "read_document"
        action_data = {document_url: "https://example.com/survey"}
        display_data = {content: "Read a document"}

        action.create(action_type, action_data, display_data)
        events = action.unpublished_events.to_a

        expect(events.size).to eq(1)
        event = events.first

        expect(event).to be_a(ActionTracking::ActionCreated)
        expect(event.data[:action_id]).to eq(action_id)
        expect(event.data[:action_type]).to eq(action_type)
        expect(event.data[:action_data]).to be_a(Hash)
        expect(event.data[:display_data][:content]).to eq(display_data[:content])
        expect(event.data[:action_data][:document_url]).to eq(action_data[:document_url])
      end
    end

    context "when creating action when already created" do
      it "raises AlreadyCreatedError" do
        action_type = "read_document"
        action_data = {document_url: "https://example.com/survey"}
        display_data = {content: "Read a document"}

        action.create(action_type, action_data, display_data)
        expect {
          action.create(action_type, action_data, display_data)
        }.to raise_error(ActionTracking::Action::AlreadyCreatedError)
      end
    end
  end

  describe "state changes" do
    it "changes state from draft to created" do
      expect(action.instance_variable_get(:@state)).to eq("draft")

      action_type = "read_document"
      action_data = {document_url: "https://example.com/survey"}
      display_data = {content: "Read a document"}

      action.create(action_type, action_data, display_data)
      expect(action.instance_variable_get(:@state)).to eq("created")
    end
  end
end
