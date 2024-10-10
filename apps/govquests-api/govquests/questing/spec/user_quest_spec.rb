require "pry"
require "spec_helper"

RSpec.describe Questing::UserQuest do
  let(:user_quest_id) { SecureRandom.uuid }
  let(:quest_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
  let(:actions) { [SecureRandom.uuid, SecureRandom.uuid] }
  let(:user_quest) { described_class.new(user_quest_id) }
  let(:quest) { Questing::Quest.new(quest_id) }
  let(:event_store) { Infra::EventStore.in_memory }

  before do
    quest.create({"title" => "Test Quest", "intro" => "Test Intro"}, "Standard", "AllUsers", [{"type" => "points", "value" => 10}])
    event_store.publish(quest.unpublished_events.to_a, stream_name: "Quest$#{quest_id}")
  end

  describe "#start" do
    context "when starting a user quest" do
      it "creates a QuestStarted event with correct data" do
        user_quest.start(quest_id, user_id, actions)
        events = user_quest.unpublished_events.to_a

        expect(events.size).to eq(1)
        event = events.first

        expect(event).to be_a(Questing::QuestStarted)
        expect(event.data[:user_quest_id]).to eq(user_quest_id)
        expect(event.data[:quest_id]).to eq(quest_id)
        expect(event.data[:user_id]).to eq(user_id)
        expect(event.data[:actions]).to eq(actions)
      end
    end

    context "when starting an already started quest" do
      it "raises QuestAlreadyStartedError" do
        user_quest.start(quest_id, user_id, actions)

        expect {
          user_quest.start(quest_id, user_id, actions)
        }.to raise_error(Questing::UserQuest::QuestAlreadyStartedError)
      end
    end
  end

  describe "#add_progress" do
    context "when adding progress to an action" do
      it "creates a QuestProgressUpdated event with correct data" do
        user_quest.start(quest_id, user_id, actions)
        action_id = actions.first
        data = {"progress" => "50%"}

        user_quest.add_progress(action_id, data)
        events = user_quest.unpublished_events.to_a

        expect(events.size).to eq(2)
        event = events.last

        expect(event).to be_a(Questing::QuestProgressUpdated)
        expect(event.data[:user_quest_id]).to eq(user_quest_id)
        expect(event.data[:action_id]).to eq(action_id)
        expect(event.data[:data]).to eq(data)
      end
    end

    context "when adding progress to an invalid action" do
      it "raises InvalidActionError" do
        user_quest.start(quest_id, user_id, actions)
        invalid_action_id = SecureRandom.uuid
        data = {"progress" => "50%"}

        expect {
          user_quest.add_progress(invalid_action_id, data)
        }.to raise_error(Questing::UserQuest::InvalidActionError, "Action #{invalid_action_id} is not part of this quest.")
      end
    end

    context "when adding progress before quest is started" do
      it "raises QuestNotStartedError" do
        action_id = actions.first
        data = {"progress" => "50%"}

        expect {
          user_quest.add_progress(action_id, data)
        }.to raise_error(Questing::UserQuest::QuestNotStartedError)
      end
    end
  end

  describe "#complete" do
    context "when completing a quest" do
      it "creates a QuestCompleted event with correct data" do
        user_quest.start(quest_id, user_id, actions)
        actions.each { |action_id| user_quest.add_progress(action_id, {}) }

        events = user_quest.unpublished_events.to_a

        expect(events.size).to eq(
          1 + # QuestStarted
          actions.size +
          1 # QuestCompleted
        )
        event = events.last

        expect(event).to be_a(Questing::QuestCompleted)
        expect(event.data[:user_quest_id]).to eq(user_quest_id)
        expect(event.data[:quest_id]).to eq(quest_id)
        expect(event.data[:user_id]).to eq(user_id)
      end
    end

    context "when completing a quest without all actions completed" do
      it "raises ActionsNotCompletedError" do
        user_quest.start(quest_id, user_id, actions)
        user_quest.add_progress(actions.first, {})

        expect {
          user_quest.complete
        }.to raise_error(Questing::UserQuest::ActionsNotCompletedError)
      end
    end
  end

  describe "state changes" do
    it "changes state from not_started to started to completed after all actions done" do
      expect(user_quest.instance_variable_get(:@state)).to eq(:not_started)

      user_quest.start(quest_id, user_id, actions)
      expect(user_quest.instance_variable_get(:@state)).to eq(:started)

      actions.each do |action_id|
        user_quest.add_progress(action_id, {})
      end

      expect(user_quest.instance_variable_get(:@state)).to eq(:completed)
    end
  end
end
