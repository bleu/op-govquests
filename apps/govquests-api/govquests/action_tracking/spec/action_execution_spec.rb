require "spec_helper"

RSpec.describe ActionTracking::ActionExecution do
  let(:action_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
  let(:quest_id) { SecureRandom.uuid }
  let(:execution_id) { ActionTracking.generate_execution_id(quest_id, action_id, user_id) }
  let(:action_type) { "read_document" }
  let(:execution) { described_class.new(execution_id) }

  describe "#start" do
    context "when starting action execution" do
      it "creates an ActionExecutionStarted event" do
        data = {document_url: "https://example.com/document"}
        nonce = SecureRandom.hex(16)
        execution.start(quest_id, action_id, action_type, user_id, data, nonce)
        events = execution.unpublished_events.to_a

        expect(events.size).to eq(1)
        event = events.first

        expect(event).to be_a(ActionTracking::ActionExecutionStarted)
        expect(event.data[:execution_id]).to eq(execution_id)
        expect(event.data[:user_id]).to eq(user_id)
        expect(event.data[:start_data]).to be_a(Hash)
      end
    end

    context "when action execution is already started" do
      it "raises AlreadyStartedError" do
        data = {document_url: "https://example.com/document"}
        nonce = SecureRandom.hex(16)
        execution.start(quest_id, action_id, action_type, user_id, data, nonce)

        expect {
          execution.start(quest_id, action_id, action_type, user_id, data, nonce)
        }.to raise_error(ActionTracking::ActionExecution::AlreadyStartedError)
      end
    end
  end

  describe "#complete" do
    context "when completing action execution" do
      it "creates an ActionExecutionCompleted event" do
        data = {document_url: "https://example.com/document"}
        nonce = SecureRandom.hex(16)
        execution.start(quest_id, action_id, action_type, user_id, data, nonce)
        start_event = execution.unpublished_events.first
        completion_data = {data: "success"}

        execution.complete(start_event.data[:nonce], completion_data)
        events = execution.unpublished_events.to_a

        expect(events.size).to eq(2)
        event = events.last

        expect(event).to be_a(ActionTracking::ActionExecutionCompleted)
        expect(event.data[:execution_id]).to eq(execution_id)
        expect(event.data[:completion_data]).to be_a(Hash)
      end
    end

    context "when completing without starting" do
      it "raises NotStartedError" do
        completion_data = {data: "success"}
        nonce = SecureRandom.hex(16)

        expect {
          execution.complete(nonce, completion_data)
        }.to raise_error(ActionTracking::ActionExecution::NotStartedError)
      end
    end

    context "when completing with invalid nonce" do
      it "raises InvalidNonceError" do
        data = {document_url: "https://example.com/document"}
        nonce = SecureRandom.hex(16)
        execution.start(quest_id, action_id, action_type, user_id, data, nonce)
        invalid_nonce = "invalidnonce"

        expect {
          execution.complete(invalid_nonce, {})
        }.to raise_error(ActionTracking::ActionExecution::InvalidNonceError)
      end
    end

    context "when completing an already completed execution" do
      it "raises AlreadyCompletedError" do
        data = {document_url: "https://example.com/document"}
        nonce = SecureRandom.hex(16)
        execution.start(quest_id, action_id, action_type, user_id, data, nonce)
        start_event = execution.unpublished_events.first
        execution.complete(start_event.data[:nonce], {})

        expect {
          execution.complete(start_event.data[:nonce], {})
        }.to raise_error(ActionTracking::ActionExecution::AlreadyCompletedError)
      end
    end
  end

  describe "state changes" do
    it "changes state from not_started to started to completed" do
      expect(execution.instance_variable_get(:@state)).to eq("not_started")

      data = {document_url: "https://example.com/document"}
      nonce = SecureRandom.hex(16)
      execution.start(quest_id, action_id, action_type, user_id, data, nonce)
      expect(execution.instance_variable_get(:@state)).to eq("started")

      start_event = execution.unpublished_events.first
      execution.complete(start_event.data[:nonce], {})
      expect(execution.instance_variable_get(:@state)).to eq("completed")
    end
  end
end
