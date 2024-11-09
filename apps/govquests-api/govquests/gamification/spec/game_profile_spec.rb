require "spec_helper"

RSpec.describe Gamification::GameProfile do
  let(:profile_id) { SecureRandom.uuid }
  let(:profile) { described_class.new(profile_id) }
  let(:token_address) { "0xabc123" }
  let(:pool_id) { SecureRandom.uuid }

  let(:safe_mock) { instance_double(Safe::ProposeErc20Transfer) }
  let(:safe_tx_hash) { "0xabcdef123456" }

  before do
    allow(Safe::ProposeErc20Transfer).to receive(:new).and_return(safe_mock)
    allow(safe_mock).to receive(:call).and_return({"safe_tx_hash" => safe_tx_hash})
  end

  describe "#update_score" do
    context "when updating score with positive points" do
      it "creates a ScoreUpdated event with correct data" do
        points = 100
        profile.update_score(points)
        events = profile.unpublished_events.to_a

        expect(events.size).to eq(1)
        event = events.first

        expect(event).to be_a(Gamification::ScoreUpdated)
        expect(event.data[:profile_id]).to eq(profile_id)
        expect(event.data[:points]).to eq(points)
      end
    end

    context "when updating score with negative points" do
      it "creates a ScoreUpdated event with negative points" do
        points = -50
        profile.update_score(points)
        events = profile.unpublished_events.to_a

        expect(events.size).to eq(1)
        event = events.first

        expect(event.data[:points]).to eq(points)
      end
    end
  end

  describe "#achieve_tier" do
    it "creates a TierAchieved event with correct data" do
      tier = "Gold"
      profile.achieve_tier(tier)
      events = profile.unpublished_events.to_a

      expect(events.size).to eq(1)
      event = events.first

      expect(event).to be_a(Gamification::TierAchieved)
      expect(event.data[:profile_id]).to eq(profile_id)
      expect(event.data[:tier]).to eq(tier)
    end
  end

  describe "#earn_badge" do
    it "creates BadgeEarned events for each badge" do
      badges = ["First Login", "Quest Master", "Top Scorer"]
      badges.each { |badge| profile.earn_badge(badge) }
      events = profile.unpublished_events.to_a

      expect(events.size).to eq(3)
      badges_awarded = events.map { |e| e.data[:badge] }
      expect(badges_awarded).to eq(badges)
    end
  end

  describe "#maintain_streak" do
    it "creates a StreakMaintained event with correct data" do
      streak = 5
      profile.maintain_streak(streak)
      events = profile.unpublished_events.to_a

      expect(events.size).to eq(1)
      event = events.first

      expect(event).to be_a(Gamification::StreakMaintained)
      expect(event.data[:streak]).to eq(streak)
    end
  end

  describe "#complete_track" do
    it "creates a TrackCompleted event with correct data" do
      track = "Governance Basics"
      profile.complete_track(track)
      events = profile.unpublished_events.to_a

      expect(events.size).to eq(1)
      event = events.first

      expect(event).to be_a(Gamification::TrackCompleted)
      expect(event.data[:track]).to eq(track)
    end
  end

  describe "#add_token_reward" do
    it "creates TokenRewardAdded event with correct data" do
      profile.add_token_reward(token_address: token_address, amount: 100, pool_id: pool_id)
      events = profile.unpublished_events.to_a

      expect(events.size).to eq(1)
      event = events.first

      expect(event).to be_a(Gamification::TokenRewardAdded)
      expect(event.data[:profile_id]).to eq(profile_id)
      expect(event.data[:token_address]).to eq(token_address)
      expect(event.data[:amount]).to eq(100)
      expect(event.data[:pool_id]).to eq(pool_id)
      expect(event.data[:total_unclaimed]).to eq(100)
    end

    it "accumulates multiple rewards for the same token" do
      profile.add_token_reward(token_address: token_address, amount: 100, pool_id: pool_id)
      profile.add_token_reward(token_address: token_address, amount: 50, pool_id: pool_id)

      events = profile.unpublished_events.to_a
      last_event = events.last

      expect(last_event.data[:total_unclaimed]).to eq(150)
    end
  end

  describe "#start_token_claim" do
    let(:user_address) { "0xdef456" }

    before do
      profile.add_token_reward(token_address: token_address, amount: 100, pool_id: pool_id)
    end

    it "creates TokenClaimStarted event with correct data" do
      expect(Safe::ProposeErc20Transfer).to receive(:new).with(
        to_address: user_address,
        value: 100,
        token_address: token_address
      ).and_return(safe_mock)
      expect(safe_mock).to receive(:call).and_return({"safe_tx_hash" => safe_tx_hash})

      profile.start_token_claim(token_address: token_address, user_address: user_address)

      events = profile.unpublished_events.select { |e| e.is_a?(Gamification::TokenClaimStarted) }
      expect(events.size).to eq(1)
      event = events.first

      expect(event.data[:profile_id]).to eq(profile_id)
      expect(event.data[:token_address]).to eq(token_address)
      expect(event.data[:user_address]).to eq(user_address)
      expect(event.data[:amount]).to eq(100)
      expect(event.data[:claim_metadata]).to eq({
        "safe_tx_hash" => safe_tx_hash
      })
      expect(event.data[:started_at]).to be_a(Time)
    end

    it "raises AlreadyClaimingError when a claim is in progress" do
      profile.start_token_claim(token_address: token_address, user_address: user_address)

      expect {
        profile.start_token_claim(token_address: token_address, user_address: user_address)
      }.to raise_error(Gamification::GameProfile::AlreadyClaimingError)
    end

    it "raises InsufficientClaimableBalance when balance is too low" do
      different_token = "0x789"
      expect {
        profile.start_token_claim(token_address: different_token, user_address: user_address)
      }.to raise_error(Gamification::GameProfile::InsufficientClaimableBalance)
    end

    it "raises an error when Safe service fails" do
      allow(safe_mock).to receive(:call).and_raise("Safe service error")

      expect {
        profile.start_token_claim(token_address: token_address, user_address: user_address)
      }.to raise_error(RuntimeError, "Safe service error")
    end
  end

  describe "#complete_token_claim" do
    let(:user_address) { "0xdef456" }
    let(:claim_metadata) { {"transaction_hash" => "0x123", "user_address" => user_address} }

    before do
      profile.add_token_reward(token_address: token_address, amount: 100, pool_id: pool_id)
      profile.start_token_claim(token_address: token_address, user_address: user_address)
    end

    it "creates TokenClaimCompleted event with correct data" do
      profile.complete_token_claim(token_address: token_address, claim_metadata: claim_metadata)

      events = profile.unpublished_events.select { |e| e.is_a?(Gamification::TokenClaimCompleted) }
      expect(events.size).to eq(1)
      event = events.first

      expect(event.data[:profile_id]).to eq(profile_id)
      expect(event.data[:token_address]).to eq(token_address)
      expect(event.data[:user_address]).to eq(user_address)
      expect(event.data[:amount]).to eq(100)
      expect(event.data[:claim_metadata]).to eq(claim_metadata)
      expect(event.data[:completed_at]).to be_a(Time)
    end

    it "raises NoActiveClaimError when completing without starting" do
      new_profile = described_class.new(SecureRandom.uuid)
      new_profile.add_token_reward(token_address: token_address, amount: 100, pool_id: pool_id)

      expect {
        new_profile.complete_token_claim(token_address: token_address, claim_metadata: claim_metadata)
      }.to raise_error(Gamification::GameProfile::NoActiveClaimError)
    end

    it "raises WrongTokenError when completing claim for different token" do
      expect {
        profile.complete_token_claim(token_address: "0x789", claim_metadata: claim_metadata)
      }.to raise_error(Gamification::GameProfile::WrongTokenError)
    end

    it "zeroes the token balance after successful claim" do
      profile.complete_token_claim(token_address: token_address, claim_metadata: claim_metadata)
      expect(profile.instance_variable_get(:@unclaimed_tokens)[token_address]).to eq(0)
    end
  end
end
