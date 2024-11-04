require "spec_helper"
require "pry"

RSpec.describe Rewarding::RewardPool do
  let(:pool_id) { SecureRandom.uuid }
  let(:quest_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
  let(:other_user_id) { SecureRandom.uuid }
  let(:pool) { described_class.new(pool_id) }

  RSpec.shared_examples "issuable reward" do |reward_type, reward_definition, initial_inventory|
    context "with #{reward_type} reward" do
      before do
        pool.create(
          quest_id: quest_id,
          reward_definition: reward_definition,
          initial_inventory: initial_inventory
        )
      end

      it "emits RewardIssued event" do
        pool.issue_reward(user_id)

        events = pool.unpublished_events.select { |event| event.is_a?(Rewarding::RewardIssued) }
        expect(events.size).to eq(1)
        event = events.last

        expect(event).to be_a(Rewarding::RewardIssued)
        expect(event.data[:pool_id]).to eq(pool_id)
        expect(event.data[:user_id]).to eq(user_id)
        expect(event.data[:reward_definition]).to eq(reward_definition)
        expect(event.data[:issued_at]).to be_a(Time)
      end

      if reward_type == "Points"
        it "allows multiple issuances to the same user" do
          pool.issue_reward(user_id)
          expect { pool.issue_reward(user_id) }.not_to raise_error

          events = pool.unpublished_events.select { |event| event.is_a?(Rewarding::RewardIssued) }
          expect(events.size).to eq(2)
        end
      end

      if reward_type == "Token"
        it "emits RewardIssued event and decrements inventory" do
          pool.issue_reward(user_id)

          events = pool.unpublished_events.select { |event| event.is_a?(Rewarding::RewardIssued) }
          expect(events.size).to eq(1)
          event = events.last

          expect(event).to be_a(Rewarding::RewardIssued)
          expect(event.data[:pool_id]).to eq(pool_id)
          expect(event.data[:user_id]).to eq(user_id)
          expect(event.data[:reward_definition]).to eq(reward_definition)
          expect(event.data[:issued_at]).to be_a(Time)

          expect(pool.instance_variable_get(:@remaining_inventory)).to eq(initial_inventory - reward_definition["amount"])
        end

        it "raises InsufficientInventory when inventory is depleted" do
          pool.issue_reward(user_id)
          expect(pool.instance_variable_get(:@remaining_inventory)).to eq(initial_inventory - reward_definition["amount"])
          expect(pool.instance_variable_get(:@remaining_inventory)).to be 0
          expect {
            pool.issue_reward(other_user_id)
          }.to raise_error(Rewarding::RewardPool::InsufficientInventory)
        end

        it "raises AlreadyIssued when issued twice to the same user" do
          pool.issue_reward(user_id)

          expect {
            pool.issue_reward(user_id)
          }.to raise_error(Rewarding::RewardPool::AlreadyIssued)
        end
      end
    end
  end

  RSpec.shared_examples "claim behavior" do |reward_type, reward_definition|
    context "with #{reward_type} reward" do
      before do
        pool.create(
          quest_id: quest_id,
          reward_definition: reward_definition,
          initial_inventory: (reward_definition["type"] == "Token") ? 2 : nil
        )
        pool.issue_reward(user_id)
      end

      if reward_type == "Points"
        it "auto emits RewardClaimStarted and RewardClaimCompleted events" do
          events = pool.unpublished_events.to_a

          claim_started_event = events.find { |event| event.is_a?(Rewarding::RewardClaimStarted) }
          claim_completed_event = events.find { |event| event.is_a?(Rewarding::RewardClaimCompleted) }

          expect(claim_started_event).to be_a(Rewarding::RewardClaimStarted)
          expect(claim_started_event.data[:pool_id]).to eq(pool_id)
          expect(claim_started_event.data[:user_id]).to eq(user_id)

          expect(claim_completed_event).to be_a(Rewarding::RewardClaimCompleted)
          expect(claim_completed_event.data[:pool_id]).to eq(pool_id)
          expect(claim_completed_event.data[:user_id]).to eq(user_id)
        end

        it "raises AlreadyStartedClaim error when attempting to start claim again" do
          expect {
            pool.start_claim(user_id)
          }.to raise_error(Rewarding::RewardPool::AlreadyStartedClaim)
        end
      elsif reward_type == "Token"
        it "emits RewardClaimStarted event when started" do
          pool.start_claim(user_id, {user_address: "0x123"})

          events = pool.unpublished_events.to_a
          claim_started_event = events.find { |event| event.is_a?(Rewarding::RewardClaimStarted) }

          expect(claim_started_event).to be_a(Rewarding::RewardClaimStarted)
          expect(claim_started_event.data[:pool_id]).to eq(pool_id)
          expect(claim_started_event.data[:user_id]).to eq(user_id)
        end

        it "raises NotIssued error when starting claim for unissued user" do
          expect {
            pool.start_claim(other_user_id, {user_address: "0x456"})
          }.to raise_error(Rewarding::RewardPool::NotIssued)
        end

        it "raises AlreadyStartedClaim error when claim is already started" do
          pool.start_claim(user_id, {user_address: "0x123"})

          expect {
            pool.start_claim(user_id, {user_address: "0x123"})
          }.to raise_error(Rewarding::RewardPool::AlreadyStartedClaim)
        end
      end
    end
  end

  RSpec.shared_examples "complete_claim behavior" do |reward_type, reward_definition|
    context "with #{reward_type} reward" do
      before do
        pool.create(
          quest_id: quest_id,
          reward_definition: reward_definition,
          initial_inventory: (reward_definition["type"] == "Token") ? 2 : nil
        )
        pool.issue_reward(user_id)
        pool.start_claim(user_id, {user_address: "0x123"}) if reward_type == "Token"
      end

      if reward_type == "Token"
        it "emits RewardClaimCompleted event" do
          pool.complete_claim(user_id, {transaction_metadata: "tx123", user_address: "0x123"})

          events = pool.unpublished_events.to_a
          claim_completed_event = events.find { |event| event.is_a?(Rewarding::RewardClaimCompleted) }

          expect(claim_completed_event).to be_a(Rewarding::RewardClaimCompleted)
          expect(claim_completed_event.data[:pool_id]).to eq(pool_id)
          expect(claim_completed_event.data[:user_id]).to eq(user_id)
          expect(claim_completed_event.data[:reward_definition]).to eq(reward_definition)
          expect(claim_completed_event.data[:claim_completed_at]).to be_a(Time)
          expect(claim_completed_event.data[:claim_metadata]).to eq({"transaction_metadata" => "tx123", "user_address" => "0x123"})
        end

        it "raises ClaimNotStarted error when completing without starting" do
          new_user_id = SecureRandom.uuid
          pool.issue_reward(new_user_id)

          expect {
            pool.complete_claim(new_user_id, {transaction_metadata: "tx456", user_address: "0x456"})
          }.to raise_error(Rewarding::RewardPool::ClaimNotStarted)
        end

        it "raises AlreadyClaimed error when completing an already completed claim" do
          pool.complete_claim(user_id, {transaction_metadata: "tx123", user_address: "0x123"})

          expect {
            pool.complete_claim(user_id, {transaction_metadata: "tx789", user_address: "0x123"})
          }.to raise_error(Rewarding::RewardPool::AlreadyClaimed)
        end
      elsif reward_type == "Points"
        it "raises AlreadyClaimed error when attempting to complete claim manually" do
          expect {
            pool.complete_claim(user_id, {})
          }.to raise_error(Rewarding::RewardPool::AlreadyClaimed)
        end
      end
    end
  end

  RSpec.shared_examples "claim edge cases" do |reward_type, reward_definition|
    context "with #{reward_type} reward" do
      it "raises AlreadyClaimed when attempting to complete claim after auto-claim" do
        if reward_type == "Points"
          expect {
            pool.complete_claim(user_id, {})
          }.to raise_error(Rewarding::RewardPool::AlreadyClaimed)
        end
      end
    end
  end

  describe "#complete_claim" do
    it_behaves_like "complete_claim behavior", "Token", {"type" => "Token", "amount" => 1, "token_address" => "0xabc"}
    it_behaves_like "complete_claim behavior", "Points", {"type" => "Points", "amount" => 100}

    context "completing claim before issuing reward" do
      before do
        pool.create(
          quest_id: quest_id,
          reward_definition: {"type" => "Token", "amount" => 1, "token_address" => "0xabc"},
          initial_inventory: 1
        )
      end

      it "raises NotIssued error" do
        expect {
          pool.complete_claim(user_id, {})
        }.to raise_error(Rewarding::RewardPool::NotIssued)
      end
    end
  end

  describe "#start_claim" do
    it_behaves_like "claim behavior", "Points", {"type" => "Points", "amount" => 100}
    it_behaves_like "claim behavior", "Token", {"type" => "Token", "amount" => 1, "token_address" => "0xabc"}
  end

  describe "#issue_reward" do
    it_behaves_like "issuable reward", "Points", {"type" => "Points", "amount" => 100}
    it_behaves_like "issuable reward", "Token", {"type" => "Token", "amount" => 1, "token_address" => "0xabc"}, 1

    context "issuing reward before creating pool" do
      it "raises NotIssued error" do
        expect {
          pool.issue_reward(user_id)
        }.to raise_error(Rewarding::RewardPool::NotIssued)
      end
    end
  end

  describe "#create" do
    context "when creating a points reward pool" do
      it "creates a RewardPoolCreated event with correct data" do
        pool.create(quest_id: quest_id, reward_definition: {"type" => "Points", "amount" => 100})

        events = pool.unpublished_events.to_a
        expect(events.size).to eq(1)
        event = events.first

        expect(event).to be_a(Rewarding::RewardPoolCreated)
        expect(event.data[:pool_id]).to eq(pool_id)
        expect(event.data[:quest_id]).to eq(quest_id)
        expect(event.data[:reward_definition]).to eq({"type" => "Points", "amount" => 100})
        expect(event.data[:initial_inventory]).to be_nil
      end
    end

    context "with token reward and inventory" do
      it "emits RewardPoolCreated event with inventory" do
        pool.create(
          quest_id: quest_id,
          reward_definition: {"type" => "Token", "amount" => 1, "token_address" => "0xabc"},
          initial_inventory: 900
        )

        events = pool.unpublished_events.to_a
        expect(events.size).to eq(1)
        event = events.first

        expect(event).to be_a(Rewarding::RewardPoolCreated)
        expect(event.data[:pool_id]).to eq(pool_id)
        expect(event.data[:quest_id]).to eq(quest_id)
        expect(event.data[:reward_definition]).to eq({"type" => "Token", "amount" => 1, "token_address" => "0xabc"})
        expect(event.data[:initial_inventory]).to eq(900)
      end
    end

    context "when creating an already created pool" do
      before do
        pool.create(quest_id: quest_id, reward_definition: {"type" => "Points", "amount" => 100})
      end

      it "raises AlreadyCreated error" do
        expect {
          pool.create(quest_id: quest_id, reward_definition: {"type" => "Points", "amount" => 100})
        }.to raise_error(Rewarding::RewardPool::AlreadyCreated)
      end
    end
  end

  describe "edge cases" do
    let(:unknown_reward_definition) { {"type" => "UnknownType", "amount" => 50} }

    it "raises UnknownRewardType when an unsupported reward type is used during issue_reward" do
      pool.create(quest_id: quest_id, reward_definition: unknown_reward_definition)

      expect {
        pool.issue_reward(user_id)
      }.to raise_error(Rewarding::RewardStrategyFactory::UnknownRewardType)
    end

    it "raises AlreadyCreated when attempting to create a pool twice with different definitions" do
      pool.create(quest_id: quest_id, reward_definition: {"type" => "Points", "amount" => 100})

      expect {
        pool.create(quest_id: quest_id, reward_definition: {"type" => "Token", "amount" => 1, "token_address" => "0xabc"})
      }.to raise_error(Rewarding::RewardPool::AlreadyCreated)
    end

    it "handles zero initial inventory gracefully" do
      pool.create(quest_id: quest_id, reward_definition: {"type" => "Token", "amount" => 1, "token_address" => "0xabc"}, initial_inventory: 0)

      expect(pool.instance_variable_get(:@remaining_inventory)).to eq(0)
    end
  end
end
