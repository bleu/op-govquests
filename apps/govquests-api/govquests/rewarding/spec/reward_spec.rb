# spec/govquests/rewarding/reward_spec.rb
require "spec_helper"

RSpec.describe Rewarding::Reward do
  let(:reward_id) { SecureRandom.uuid }
  let(:reward) { described_class.new(reward_id) }

  describe "#create" do
    context "when creating a new reward" do
      it "creates a RewardCreated event with correct data" do
        reward_type = "points"
        value = 100
        expiry_date = Time.now + 30 * 24 * 60 * 60

        reward.create(reward_type, value, expiry_date)
        events = reward.unpublished_events.to_a

        expect(events.size).to eq(1)
        event = events.first

        expect(event).to be_a(Rewarding::RewardCreated)
        expect(event.data[:reward_id]).to eq(reward_id)
        expect(event.data[:reward_type]).to eq(reward_type)
        expect(event.data[:value]).to eq(value)
        expect(event.data[:expiry_date]).to eq(expiry_date)
      end
    end

    context "when creating a reward with missing value and expiry_date" do
      it "sets value and expiry_date to nil" do
        reward_type = "points"
        value = nil
        expiry_date = nil

        expect { reward.create(reward_type, value, expiry_date) }.to raise_error(Dry::Struct::Error)
      end
    end
  end

  describe "#issue" do
    context "when issuing a reward to a user" do
      it "creates a RewardIssued event with correct data" do
        reward.create("points", 100)
        user_id = SecureRandom.uuid

        reward.issue(user_id)
        events = reward.unpublished_events.to_a

        expect(events.size).to eq(2)
        event = events.last

        expect(event).to be_a(Rewarding::RewardIssued)
        expect(event.data[:reward_id]).to eq(reward_id)
        expect(event.data[:user_id]).to eq(user_id)
      end
    end

    context "when issuing a reward before creation" do
      it "raises Rewarding::Reward::NotCreated" do
        user_id = SecureRandom.uuid

        expect {
          reward.issue(user_id)
        }.to raise_error(Rewarding::Reward::NotCreated)
      end
    end
  end

  describe "#claim" do
    context "when claiming a reward" do
      it "creates a RewardClaimed event with correct data" do
        reward.create("points", 100)
        user_id = SecureRandom.uuid
        reward.issue(user_id)

        reward.claim(user_id)
        events = reward.unpublished_events.to_a

        expect(events.size).to eq(3)
        event = events.last

        expect(event).to be_a(Rewarding::RewardClaimed)
        expect(event.data[:reward_id]).to eq(reward_id)
        expect(event.data[:user_id]).to eq(user_id)
      end
    end

    context "when claiming a reward not issued" do
      it "raises Rewarding::Reward::NotIssued" do
        reward.create("points", 100)
        user_id = SecureRandom.uuid

        expect {
          reward.claim(user_id)
        }.to raise_error(Rewarding::Reward::NotIssued)
      end
    end

    context "when claiming an already claimed reward" do
      it "raises AlreadyClaimed error" do
        reward.create("points", 100)
        user_id = SecureRandom.uuid
        reward.issue(user_id)
        reward.claim(user_id)

        expect {
          reward.claim(user_id)
        }.to raise_error(Rewarding::Reward::AlreadyClaimed)
      end
    end

    context "when claiming a reward by a different user" do
      it "raises Rewarding::Reward::NotIssuedToUser" do
        reward.create("points", 100)
        issued_user_id = SecureRandom.uuid
        claiming_user_id = SecureRandom.uuid
        reward.issue(issued_user_id)

        expect { reward.claim(claiming_user_id) }.to raise_error(Rewarding::Reward::NotIssuedToUser)
      end
    end
  end
end
